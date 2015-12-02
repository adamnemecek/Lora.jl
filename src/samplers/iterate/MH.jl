function codegen_iterate_mh(job::BasicMCJob, outopts::Dict)
  result::Expr
  update::Vector{Expr}
  noupdate = []
  body = []

  if job.tuner.verbose
    push!(body, :($(:_sstate).tune.proposed += 1))
  end

  push!(body, :($(:_sstate).pstate.value = $(:_sampler).randproposal($(:_pstate).value)))
  push!(body, :($(:_parameter).logtarget!($(:_sstate).pstate, $(:_vstate))))

  if job.sampler.symmetric
    push!(body, :($(:_sstate).ratio = $(:_sstate).pstate.logtarget-$(:_pstate).logtarget))
  else
    push!(body, :($(:_sstate).ratio = (
      $(:_sstate).pstate.logtarget
      +$(:_sampler).logproposal($(:_sstate).pstate.value, $(:_pstate).value)
      -$(:_pstate).logtarget
      -$(:_sampler).logproposal($(:_pstate).value, $(:_sstate).pstate.value)
    )))
  end

  update = [
    :($(:_pstate).value = copy($(:_sstate).pstate.value)),
    :($(:_pstate).logtarget = copy($(:_sstate).pstate.logtarget))
  ]
  if in(:accept, outopts[:diagnostics])
    push!(update, :($(:_pstate).diagnosticvalues[1] = true))
    push!(noupdate, :($(:_pstate).diagnosticvalues[1] = false))
  end
  if job.tuner.verbose
    push!(update, :($(:_sstate).tune.accepted += 1))
  end
  push!(body, Expr(:if, :($(:_sstate).ratio > 0 || ($(:_sstate).ratio > log(rand()))), Expr(:block, update...), noupdate...))

  if job.tuner.verbose
    push!(body, :(
      if $(:_sstate).tune.proposed <= $(:_range).burnin && mod($(:_sstate).tune.proposed, $(:_tuner).period) == 0
        rate!($(:_sstate).tune)
        println(
          "Burnin iteration ",
          $(:_sstate).tune.proposed,
          " of ",
          $(:_range).burnin,
          ": ",
          round(100*$(:_sstate).tune.rate, 2),
          " % acceptance rate"
        )
      end
    ))
  end

  if !job.plain
    push!(body, :(produce()))
  end

  @gensym iterate_mh

  if isa(job.pstate, BasicContUnvParameterState) &&
    isa(job.sstate.pstate, BasicContUnvParameterState) &&
    isa(job.parameter, BasicContUnvParameter)
    result = quote
      function $iterate_mh{N<:Real, S<:VariableState}(
        _pstate::BasicContUnvParameterState{N},
        _vstate::Vector{S},
        _sstate::MHState{BasicContUnvParameterState{N}},
        _parameter::BasicContUnvParameter,
        _sampler::MH,
        _tuner::MCTuner,
        _range::BasicMCRange
      )
        $(body...)
      end
    end
  elseif isa(job.pstate, BasicContMuvParameterState) &&
    isa(job.sstate.pstate, BasicContMuvParameterState) &&
    isa(job.parameter, BasicContMuvParameter)
    result = quote
      function $iterate_mh{N<:Real, S<:VariableState}(
        _pstate::BasicContMuvParameterState{N},
        _vstate::Vector{S},
        _sstate::MHState{BasicContMuvParameterState{N}},
        _parameter::BasicContMuvParameter,
        _sampler::MH,
        _tuner::MCTuner,
        _range::BasicMCRange
      )
        $(body...)
      end
    end
  else
      error("It is not possible to define iterate!() for given job")
  end

  result
end
