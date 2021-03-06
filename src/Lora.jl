module Lora

using Distributions
using Formatting
using Graphs
using StatsBase

import Base:
  ==,
  Dict,
  close,
  convert,
  copy!,
  eltype,
  flush,
  getindex,
  isequal,
  keys,
  mark,
  mean,
  mean!,
  open,
  rand,
  read!,
  read,
  reset,
  run,
  show,
  write,
  writemime

import Distributions:
  @check_args,
  @distr_support,
  failprob,
  logpdf,
  params,
  pdf,
  succprob

import ForwardDiff

import Graphs:
  add_edge!,
  add_vertex!,
  edge_index,
  edges,
  in_degree,
  in_edges,
  in_neighbors,
  is_directed,
  make_edge,
  num_edges,
  num_vertices,
  out_degree,
  out_edges,
  out_neighbors,
  revedge,
  source,
  target,
  topological_sort_by_dfs,
  vertex_index,
  vertices

import ReverseDiffSource

export
  ### Types
  AM,
  AMState,
  # AMWG,
  # AMWGJob,
  # AMWGState,
  ARS,
  ARSState,
  AcceptanceRateMCTuner,
  BasicContMuvParameter,
  BasicContMuvParameterNState,
  BasicContMuvParameterState,
  BasicContParamIOStream,
  BasicContUnvParameter,
  BasicContUnvParameterNState,
  BasicContUnvParameterState,
  BasicDiscMuvParameter,
  BasicDiscMuvParameterNState,
  BasicDiscMuvParameterState,
  BasicDiscParamIOStream,
  BasicDiscUnvParameter,
  BasicDiscUnvParameterNState,
  BasicDiscUnvParameterState,
  BasicGibbsJob,
  BasicMCJob,
  BasicMCRange,
  BasicMCTune,
  BasicMavVariableNState,
  BasicMavVariableState,
  BasicMuvVariableNState,
  BasicMuvVariableState,
  BasicUnvVariableNState,
  BasicUnvVariableState,
  BasicVariableIOStream,
  Binary,
  Constant,
  ContMuvMarkovChain,
  ContUnvMarkovChain,
  ContinuousParameter,
  ContinuousParameterNState,
  ContinuousParameterState,
  Data,
  Dependence,
  DependenceVector,
  Deterministic,
  DiscMuvMarkovChain,
  DiscUnvMarkovChain,
  DiscreteParameter,
  DiscreteParameterNState,
  DiscreteParameterState,
  GenericModel,
  GibbsJob,
  HMC,
  HMCSampler,
  HMCState,
  Hyperparameter,
  IntegerVector,
  LMCSampler,
  MALA,
  MALAState,
  MCJob,
  MCRange,
  MCSampler,
  MCSamplerState,
  MCTuner,
  MCTunerState,
  MH,
  MHSampler,
  MHState,
  MarkovChain,
  MatrixvariateParameter,
  MatrixvariateParameterNState,
  MatrixvariateParameterState,
  MultivariateParameter,
  MultivariateParameterNState,
  MultivariateParameterState,
  MuvAMState,
  MuvAMWGState,
  MuvHMCState,
  MuvMALAState,
  MuvSMMALAState,
  Parameter,
  ParameterIOStream,
  ParameterNState,
  ParameterState,
  ParameterStateVector,
  ParameterVector,
  RAM,
  Random,
  RealMatrix,
  RealVector,
  RobertsRosenthalMCTune,
  RobertsRosenthalMCTuner,
  SMMALA,
  SMMALAState,
  Sampleability,
  Transformation,
  UnivariateParameter,
  UnivariateParameterNState,
  UnivariateParameterState,
  UnvAMWGState,
  UnvHMCState,
  UnvMALAState,
  UnvSMMALAState,
  VanillaMCTuner,
  Variable,
  VariableIOStream,
  VariableNState,
  VariableState,
  VariableStateVector,
  VariableVector,

  ### Functions
  acceptance,
  add_dimension,
  add_edge!,
  add_vertex!,
  codegen,
  count!,
  covariance!,
  dataset,
  datasets,
  diagnostics,
  edge_index,
  edges,
  erf_rate_score,
  ess,
  examples,
  failprob,
  iact,
  in_degree,
  in_edges,
  in_neighbors,
  indices,
  is_directed,
  is_indexed,
  iterate,
  job2dot,
  likelihood_model,
  logistic,
  logistic_rate_score,
  lognormalise,
  logpdf,
  lzv,
  make_edge,
  mcse,
  mcvar,
  model2dot,
  normalise,
  num_edges,
  num_vertices,
  out_degree,
  out_edges,
  out_neighbors,
  output,
  qzv,
  params,
  pdf,
  rate!,
  reset!,
  reset_burnin!,
  revedge,
  run,
  sampler_state,
  save!,
  save,
  setpdf!,
  setprior!,
  softabs,
  sort_by_index,
  source,
  succprob,
  target,
  topological_sort_by_dfs,
  tune!,
  tuner_state,
  vertex_index,
  vertex_key,
  vertices

include("base.jl")

include("format.jl")

include("data.jl")

include("codegen.jl")

include("stats/logistic.jl")

include("distributions/Binary.jl")
include("distributions/TruncatedNormal.jl")

include("autodiff/reverse.jl")
include("autodiff/forward.jl")

include("states/VariableStates.jl")
include("states/ParameterStates/ParameterStates.jl")
include("states/ParameterStates/BasicDiscUnvParameterState.jl")
include("states/ParameterStates/BasicDiscMuvParameterState.jl")
include("states/ParameterStates/BasicContUnvParameterState.jl")
include("states/ParameterStates/BasicContMuvParameterState.jl")

include("nstates/VariableNStates.jl")
include("nstates/ParameterNStates/ParameterNStates.jl")
include("nstates/ParameterNStates/BasicDiscUnvParameterNState.jl")
include("nstates/ParameterNStates/BasicDiscMuvParameterNState.jl")
include("nstates/ParameterNStates/BasicContUnvParameterNState.jl")
include("nstates/ParameterNStates/BasicContMuvParameterNState.jl")

include("iostreams/VariableIOStreams.jl")
include("iostreams/ParameterIOStreams/ParameterIOStreams.jl")
include("iostreams/ParameterIOStreams/BasicDiscParamIOStream.jl")
include("iostreams/ParameterIOStreams/BasicContParamIOStream.jl")

include("variables/variables.jl")
include("variables/parameters/parameters.jl")
include("variables/parameters/BasicDiscUnvParameter.jl")
include("variables/parameters/BasicDiscMuvParameter.jl")
include("variables/parameters/BasicContUnvParameter.jl")
include("variables/parameters/BasicContMuvParameter.jl")
include("variables/dependencies.jl")

include("models/GenericModel.jl")
include("models/generators.jl")

include("ranges/ranges.jl")
include("ranges/BasicMCRange.jl")

include("tuners/tuners.jl")
include("tuners/VanillaMCTuner.jl")
include("tuners/AcceptanceRateMCTuner.jl")
include("tuners/RobertsRosenthalMCTuner.jl")

include("samplers/samplers.jl")
include("samplers/ARS.jl")
include("samplers/MH.jl")
include("samplers/AM.jl")
include("samplers/RAM.jl")
include("samplers/HMC.jl")
include("samplers/MALA.jl")
include("samplers/SMMALA.jl")
include("samplers/AMWG.jl")

include("jobs/jobs.jl")
include("jobs/BasicMCJob.jl")
include("jobs/BasicGibbsJob.jl")
# include("jobs/AMWGJob.jl")

include("samplers/iterate/ARS.jl")
include("samplers/iterate/MH.jl")
include("samplers/iterate/AM.jl")
include("samplers/iterate/RAM.jl")
include("samplers/iterate/HMC.jl")
include("samplers/iterate/MALA.jl")
include("samplers/iterate/SMMALA.jl")
include("samplers/iterate/iterate.jl")

include("stats/acceptance.jl")

include("stats/mean.jl")

include("stats/variance/mcvar.jl")
include("stats/variance/zv.jl")

include("stats/covariance.jl")

include("stats/convergence/ess.jl")
include("stats/convergence/iact.jl")

include("stats/metrics.jl")

end
