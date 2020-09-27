---
class: Workflow
cwlVersion: v1.0
steps:
  Transcribe:
    run: tools/transcribe.cwl
    in:
      input_file: input_file
      verbose:
        default: true
    out:
    - output_file_glob
  Translate:
    run: tools/translate.cwl
    in:
      input_file: Transcribe/output_file_glob
      output_filename: output_filename
    out:
    - output_protein
inputs:
  output_filename:
    type:
    - 'null'
    - string
  input_file:
    type:
    - File
    label: input_file
outputs:
  output_protein:
    type: File
    label: output_protein
    outputSource: Translate/output_protein
label: dna2protein
