from cwl_airflow.extensions.cwldag import CWLDAG

dag = CWLDAG(workflow="/home/airflow/sample-workflows/alpine-docker/alpine-docker-app.cwl",dag_id="alpine_docker-dag")