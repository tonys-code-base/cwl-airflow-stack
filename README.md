# CWL-Airflow Docker Compose Stack

This repo contains an Airflow Docker Compose stack which includes package [cwl-airflow v1.2.2](https://pypi.org/project/cwl-airflow/).

1. Create host user `airflow` and add to groups `docker, sudo`. All of the following commands to be executed with this user
2. Clone this repo to tmp location and move relevant contents to `/home/airflow`

```
$ cd /home/airflow
$ mkdir tmp
$ git clone https://github.com/tonys-code-base/cwl-airflow-stack.git /home/airflow/tmp
$ rm -fr /home/airflow/tmp/.git /home/airflow/tmp/.gitignore
$ mv /home/airflow/tmp/* /home/airflow/
$ rm -fr /home/airflow/tmp
```

3. Build the docker image with tag of `cwl-airflow-docker`

```
$ cd /home/airflow/cwl-airflow-docker
$ docker build -t cwl-airflow-docker .
```

4. Bring up the stack

```
$ cd /home/airflow
$ docker-compose up -d
```

5. The Airflow Web UI can be accessed using the following details

* Web UI: `http://localhost:8080/`
* Username: `admin`
* Password: `admin`

6. To execute one of the CWL-Airflow workflow samples (`snpeff-dag`) included in the repo with components located at,

```
/home/airflow/dags/snpeff-workflow-dag.py
/home/airflow/sample-workflows/snpeff/*
```

first install `gridsite-clients` followed by a call to the `dag_runs` endpoint

```
$ sudo apt install gridsite-clients

$ curl -X POST "http://localhost:8081/api/experimental/dag_runs?\
dag_id=snpeff-dag&\
conf=\
"$(urlencode {\"job\":\
$(cat /home/airflow/sample-workflows/snpeff/snpeff-workflow-inputs.json)})
```

7. Workflow outputs can be located at:

```
/home/airflow/cwl_outputs_folder/<dag_id>/*
```