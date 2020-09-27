class: CommandLineTool
cwlVersion: v1.0
label: Translate
requirements:
- class: InitialWorkDirRequirement
  listing:
  - entry: "#!/usr/bin/env/python\nimport argparse\nimport sys\n\ndef translate(args):\n\tmRNA
      = args['mRNA'].read().strip()\n\tcodon_map = {\"UUU\":\"F\", \"UUC\":\"F\",
      \"UUA\":\"L\", \"UUG\":\"L\",\n    \"UCU\":\"S\", \"UCC\":\"S\", \"UCA\":\"S\",
      \"UCG\":\"S\",\n    \"UAU\":\"Y\", \"UAC\":\"Y\", \"UAA\":\"STOP\", \"UAG\":\"STOP\",\n
      \   \"UGU\":\"C\", \"UGC\":\"C\", \"UGA\":\"STOP\", \"UGG\":\"W\",\n    \"CUU\":\"L\",
      \"CUC\":\"L\", \"CUA\":\"L\", \"CUG\":\"L\",\n    \"CCU\":\"P\", \"CCC\":\"P\",
      \"CCA\":\"P\", \"CCG\":\"P\",\n    \"CAU\":\"H\", \"CAC\":\"H\", \"CAA\":\"Q\",
      \"CAG\":\"Q\",\n    \"CGU\":\"R\", \"CGC\":\"R\", \"CGA\":\"R\", \"CGG\":\"R\",\n
      \   \"AUU\":\"I\", \"AUC\":\"I\", \"AUA\":\"I\", \"AUG\":\"M\",\n    \"ACU\":\"T\",
      \"ACC\":\"T\", \"ACA\":\"T\", \"ACG\":\"T\",\n    \"AAU\":\"N\", \"AAC\":\"N\",
      \"AAA\":\"K\", \"AAG\":\"K\",\n    \"AGU\":\"S\", \"AGC\":\"S\", \"AGA\":\"R\",
      \"AGG\":\"R\",\n    \"GUU\":\"V\", \"GUC\":\"V\", \"GUA\":\"V\", \"GUG\":\"V\",\n
      \   \"GCU\":\"A\", \"GCC\":\"A\", \"GCA\":\"A\", \"GCG\":\"A\",\n    \"GAU\":\"D\",
      \"GAC\":\"D\", \"GAA\":\"E\", \"GAG\":\"E\",\n    \"GGU\":\"G\", \"GGC\":\"G\",
      \"GGA\":\"G\", \"GGG\":\"G\",}\n\n\tprotein = ''\n\t# find the start codon and
      proceed until a 'STOP'\n\tstart = mRNA.find('AUG')\n\tif start != -1:\n\t\twhile
      start+2 < len(mRNA):\n\t\t\tprotein += codon_map[mRNA[start:start+3]]\n\t\t\tstart
      += 3\n\t\tprotein = protein[:protein.find('STOP')]\n\tprint protein\n\nif __name__
      == \"__main__\":\n\t\"\"\" Parse the command line arguments \"\"\"\n\tparser
      = argparse.ArgumentParser()\n\tparser.add_argument(\"-r\", \"--mRNA\", type=argparse.FileType('r'),
      default=sys.stdin)\n\targs = vars(parser.parse_args())\n\n\t\"\"\" Run the main
      method \"\"\"\n\ttranslate(args)"
    entryname: translate.py
- class: InlineJavascriptRequirement
inputs:
  input_file:
    type: File
    inputBinding:
      position: 3
      prefix: "-r"
  output_filename:
    type:
    - 'null'
    - string
outputs:
  output_protein:
    type: File
    outputBinding:
      glob: "*.txt"
hints:
- class: DockerRequirement
  dockerPull: python:2-alpine
baseCommand:
- python
- translate.py
stdout: "${return inputs.output_filename || 'protein' + '.txt'}"
