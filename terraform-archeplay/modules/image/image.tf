#Base instance's AMI
data "aws_ami" "ami_ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

#Creation of Base instance with wordpress
resource "aws_instance" "wordpress" {
  ami                    = data.aws_ami.ami_ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  security_groups = [var.security_groups]
  key_name = "docker-practice"
  user_data = <<-EOF
		#! /bin/bash
    sudo apt-get update
		sudo apt install -y curl unzip tasksel
		sudo tasksel install lamp-server
		sudo a2enmod rewrite
		sudo systemctl restart apache2
    curl --output /tmp/wordpress.zip https://wordpress.org/latest.zip
    sudo rm -fr /var/www/html
    sudo unzip /tmp/wordpress.zip -d /var/www/
    sudo mv /var/www/wordpress/ /var/www/html
    sudo chown -R www-data.www-data /var/www/html
    sudo mysqladmin create wordpress
    sudo mysql -e "CREATE USER 'admin'@'%' IDENTIFIED BY 'pass';"
    sudo mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'admin'@'%' WITH GRANT OPTION;"
    EOF

  tags = {
    Name = "wordpress"
  }
}

#Creating AMI from the Base instance
resource "aws_ami_from_instance" "wordpress_ami" {
  name = "wordpress_ami"
  source_instance_id = aws_instance.wordpress.id

  tags = {
    Name = "wordpress_ami"
  }
}