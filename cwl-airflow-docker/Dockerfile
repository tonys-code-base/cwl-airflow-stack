# VERSION 1.10.11
# AUTHOR:Tony Tannous
# DESCRIPTION: Docker image for CWL-Airflow v1.2.2/Airflow v1.10.11
# BUILD: docker build -t cwl-airflow-docker .
# SOURCE: https://github.com/tonys-code-base/cwl-airflow-stack/cwl-airflow-docker

FROM python:3.7

ENV DEBIAN_FRONTEND=noninteractive
LABEL maintainer="tonyt_"

ARG AIRFLOW_USER_HOME=/home/airflow
ENV AIRFLOW_HOME=${AIRFLOW_USER_HOME}

RUN apt-get update -y -qq \
    && apt-get install -y -qq \
    python3-dev \
    netcat \
    nodejs \
    gridsite-clients \
    freetds-bin \
    krb5-user \
    ldap-utils \
    libffi6 \
    libsasl2-2 \
    libsasl2-modules \
    libssl1.1 \
    locales  \
    lsb-release \
    sasl2-bin \
    sqlite3 \
    unixodbc \
    default-libmysqlclient-dev \
    && apt-get clean \
    && useradd -ms /bin/bash -d ${AIRFLOW_USER_HOME} airflow \
    && groupadd docker \
    && usermod -aG docker airflow

RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-19.03.12.tgz \
  && tar xzvf docker-19.03.12.tgz --strip 1 \
  -C /usr/local/bin docker/docker \
  && rm docker-19.03.12.tgz

EXPOSE 8081 5555 8793 3070

WORKDIR ${AIRFLOW_USER_HOME}

COPY airflow.sh airflow.sh
COPY api_user_setup.py api_user_setup.py
COPY Pipfile.lock Pipfile.lock
COPY Pipfile Pipfile

COPY config.env config.env

RUN chown -R airflow: ${AIRFLOW_USER_HOME}

RUN pip3 install pipenv
RUN pipenv install --system --deploy --ignore-pipfile

RUN chmod +x airflow.sh

USER airflow

ENTRYPOINT ["./airflow.sh"]
CMD ["webserver"]
