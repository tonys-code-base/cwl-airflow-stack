class: CommandLineTool
cwlVersion: v1.0
baseCommand: []
inputs:
  - id: genome
    type: string
    inputBinding:
      position: 1
  - id: input_vcf
    type: File
    inputBinding:
      position: 2
    doc: VCF file to annotate
outputs:
  - id: genes
    type: File
    outputBinding:
      glob: '*.txt'
  - id: output
    type: stdout
  - id: stats
    type: File
    outputBinding:
      glob: '*.html'
requirements:
  - class: DockerRequirement
    dockerImageId: andrewjesaitis-snpeff
    dockerFile: 
        $include: Dockerfile
stdout: output.vcf
