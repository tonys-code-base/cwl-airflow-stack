class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
baseCommand:
  - python
  - ./transcribe_argparse.py
inputs:
  - id: input_file
    type: File
    inputBinding:
      position: 3
      prefix: '-d'
  - id: output_filename
    type: string?
  - id: verbose
    type: boolean?
    inputBinding:
      position: 4
      prefix: '--verbose'
outputs:
  - id: output_file_glob
    type: File
    outputBinding:
      glob: '*.txt'
label: Transcribe
requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entryname: transcribe_argparse.py
        entry: "#!/usr/bin/env/python\nimport argparse\nimport re\nimport sys\n\ndef transcribe(args):\n\t# create a transcription map and use regex to translate\n\tmap = {\"A\":\"U\", \"T\":\"A\", \"C\":\"G\", \"G\":\"C\"}\n\tmap = dict((re.escape(k), v) for k, v in map.iteritems())\n\tpattern = re.compile(\"|\".join(map.keys()))\n\tDNA = args['dna'].read().strip()\n\tmRNA = pattern.sub(lambda m: map[re.escape(m.group(0))], DNA)\n\n\t# write a verbose output to stderr and just mRNA to sdtout \n\tif args['verbose']:\n\t\tsys.stderr.write(\"Your original DNA sequence: \" + DNA + \"\\n\")\n\t\tsys.stderr.write(\"Your translated mRNA sequence: \" + mRNA + \"\\n\")\n\tsys.stdout.write(mRNA + '\\n')\n\tsys.exit(0)\n\treturn mRNA\n\nif __name__ == \"__main__\":\n\t\"\"\" Parse the command line arguments \"\"\"\n\tparser = argparse.ArgumentParser()\n\tparser.add_argument(\"-d\", \"--dna\", type=argparse.FileType(\"r\"), default=sys.stdin)\n\tparser.add_argument(\"-v\", \"--verbose\", action=\"store_true\", default=False)\n\t# By setting args as var(...), it becomes a dict, so 'dna' is a key\n\t# Alternative use: args = parser.parse_args(), and 'dna' is an attr of args!\n\t# You must change how you call the args you parse based on this usage! \n\targs = vars(parser.parse_args())\n\n\t\"\"\" Run the desired methods \"\"\"\n\ttranscribe(args)"
        writable: false
  - class: InlineJavascriptRequirement
hints:
  - class: DockerRequirement
    dockerPull: 'python:2-alpine'
stdout: '${return inputs.output_filename || ''rna'' + ''.txt''}'
