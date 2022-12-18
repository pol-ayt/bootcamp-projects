#! /bin/bash
yum update -y
yum install python3 -y
pip3 install flask
pip3 install flask_mysql
yum install git -y
echo "${aws_db_instance.mysql-db.endpoint}" > /home/ec2-user/phonebook/dbserver.endpoint
cd /home/ec2-user
FOLDER="https://raw.githubusercontent.com/clarusway-aws-devops/project-202-pol-ayt/main"
wget ${FOLDER}/phonebook-app.py
mkdir templates && cd templates
wget ${FOLDER}/templates/index.html
wget ${FOLDER}/templates/add-update.html
wget ${FOLDER}/templates/delete.html
cd ..
python3 app.py



