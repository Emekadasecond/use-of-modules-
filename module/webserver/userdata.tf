locals {
  userdata1 = <<-EOF
#!/bin/bash
sudo yum install httpd php php-mysqlnd -y
cd /var/www/html
echo "This is a test file" > indextest.html
sudo yum install wget -y
wget https://wordpress.org/wordpress-6.3.1.tar.gz
tar -xzf wordpress-6.3.1.tar.gz
sudo cp -r wordpress/* /var/www/html/
rm -rf wordpress
rm -rf wordpress-6.3.1.tar.gz
sudo chmod -R 755 wp-content
sudo chown -R apache:apache wp-content
cd /var/www/html && mv wp-config-sample.php wp-config.php
sed -i "s@define( 'DB_NAME', 'database_name_here' )@define( 'DB_NAME', 'wordpress')@g" /var/www/html/wp-config.php
sed -i "s@define( 'DB_USER', 'username_here' )@define( 'DB_USER', 'admin')@g" /var/www/html/wp-config.php
sed -i "s@define( 'DB_PASSWORD', 'password_here' )@define( 'DB_PASSWORD', 'admin123')@g" /var/www/html/wp-config.php
sed -i "s@define( 'WP_DEBUG', false )@define( 'WP_DEBUG', true )@g" /var/www/html/wp-config.php
sed -i "s@define( 'DB_HOST', 'localhost' )@define( 'DB_HOST', '${element(split(":", var.db-endpoint), 0)}' )@g" /var/www/html/wp-config.php
chkconfig httpd on
sudo systemctl restart httpd
sudo chmod 777 -R /var/www/html/

sudo setenforce 0
sudo systemctl restart httpd
EOF  
}