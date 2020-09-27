from cwl_airflow.extensions.cwldag import CWLDAG

dag = CWLDAG(workflow="/home/airflow/sample-workflows/dna2protein/dna2protein.cwl",dag_id="dna2protein_dag")
