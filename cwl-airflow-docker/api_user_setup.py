# -*- coding: utf-8 -*-

# AUTHOR:Tony Tannous
# DESCRIPTION: Script to create Airflow v1.10.11 API user and HTTP Authorization header/token

import argparse
from airflow import models
from airflow.settings import Session
from airflow.contrib.auth.backends.password_auth import PasswordUser
import base64

# Script is based off the existing airflow code for password_auth.  
# Refer to the Airflow experimental api password auth source at the links below.
# 1) https://github.com/apache/airflow/blob/v1-10-stable/airflow/contrib/auth/backends/password_auth.py
# 2) https://github.com/apache/airflow/blob/v1-10-stable/tests/www/api/experimental/test_password_endpoints.py

def userSetUp(apiUser, apiPassword):
    session = Session()
    user = models.User()
    password_user = PasswordUser(user)
    password_user.username = apiUser
    password_user.password = apiPassword
    session.add(password_user)
    session.commit()
    session.close()

def deleteApiUser(apiUser):
    session = Session()
    session.query(models.User).filter(models.User.username == apiUser).delete()
    session.commit()
    session.close()

if __name__ == "__main__":

    ap = argparse.ArgumentParser()
    
    # Add the arguments to the parser
    ap.add_argument("-api",choices=['add', 'del'], required=True ,help="ADD or DELETE an API User")
    ap.add_argument("-u", "--username", required=True,type=str,help="Api username")
    ap.add_argument("-p", "--password", required=False,type=str,help="Password")
    args = vars(ap.parse_args())
    
    if args['api'] == 'del':
        if args['password']:
            print("'-p, --password' must not be supplied for deletes")
        else:
            deleteApiUser(args['username'])
            print(f"* Ok. User {args['username']} has been deleted")

    if args['api'] == 'add':
        if (args['password'] is None):
            print("* Failure: Password not supplied for user")
        else:
            userSetUp(args['username'], args['password'])
            print(f"* Ok --> User {args['username']} has been created.")
            userPass = f"{args['username']}:{args['password']}".encode("utf-8")
            b64decodeUserPass = base64.b64encode(userPass).decode('utf-8')
            authHeader = f'Authorization: Basic {b64decodeUserPass}'

            print(f"* Use the following in the RestAPI header to authenticate --> {authHeader}")
            
            print(f"You can test the credentials using the following curl command:\r\n\
curl -v -X GET \
-H \"{authHeader}\" \
\"httpx://<host>:port/api/experimental/test\"\r\n")
