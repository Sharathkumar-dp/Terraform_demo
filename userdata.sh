#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo service httpd start
sudo service enable httpd
echo " Hello World from terraform Demo host -  $(hostname -f)  " > /var/www/html/index.html

