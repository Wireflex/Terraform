# набор команд, который запустится при создании инстанса

#!/bin/bash
yum update -y
yum install httpd -y
cat <<EOF > /var/www/html/index.html
<html>
<h2>Build by Power of Terraform <font color="red"> v0.12</font></h2><br>
</html>
EOF
systemctl start httpd
systemctl enable httpd

#=================================================================================# 

Если добавить templates,то файл переименовываем в user_data.sh.tpl

#!/bin/bash
yum update -y
yum install httpd -y
cat <<EOF > /var/www/html/index.html
<html>
<h2>Build by Power of Terraform <font color="red"> v0.12</font></h2><br>
Owner ${f_name} ${l_name} <br>

%{ for x in names ~}
Hello to ${x} from ${f_name}<br>
%{ endfor ~}

</html>
EOF

systemctl start httpd
systemctl enable httpd
