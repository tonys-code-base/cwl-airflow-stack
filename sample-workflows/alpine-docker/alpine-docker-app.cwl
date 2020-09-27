cwlVersion: v1.0
class: Workflow

requirements:
  ScatterFeatureRequirement: {}

inputs:
  message: string[]

steps:
  echo:
    run: tools/alpine-docker.cwl
    scatter: message
    in:
      message: message
    out: []

outputs: []