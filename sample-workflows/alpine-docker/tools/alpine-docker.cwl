cwlVersion: v1.0
class: CommandLineTool
label: Alpine Docker Image
baseCommand:
  - echo
inputs:
  - id: message
    type: string
    inputBinding:
      position: 1
outputs:
  - id: std_out
    type: stdout
requirements:
  - class: DockerRequirement
    dockerPull: alpine
stdout: output.txt
