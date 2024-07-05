#!/bin/bash
sudo apt update -y
sudo apt install apache2 -y
cat <<EOF > /var/www/html/index.html
<html>
<h2>Final version of Terraform lesson <font color="red"> 05.07.2024</font></h2><br>
</html>
EOF
systemctl start apache2
systemctl enable apache2
