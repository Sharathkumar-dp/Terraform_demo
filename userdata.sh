#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo service httpd start
sudo service enable httpd
echo " <html> <body> <h1>Hello World!...</h1> <p>This is terraform demo Instance</p> <p> Hostaname:- </p>  </body>  </html>  $(hostname -f)  " > /var/www/html/index.html