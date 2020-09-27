from cwl_airflow.extensions.cwldag import CWLDAG

dag = CWLDAG(workflow="/home/airflow/sample-workflows/snpeff/snpeff-workflow.cwl",dag_id="snpeff-dag")
