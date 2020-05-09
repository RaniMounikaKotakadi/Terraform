#Launch Configuration from the Custom AMI created from Base instance
resource "aws_launch_configuration" "wordpress_lc" {
  name = "wordpress_lc"
  image_id = var.image_id
  instance_type = "t2.micro"
  key_name = var.key_name
  security_groups = [var.security_groups]
  associate_public_ip_address = false

  lifecycle {
    create_before_destroy = true
  }
}

#AutoScaling group
resource "aws_autoscaling_group" "wordpress_asg" {
  name = "${aws_launch_configuration.wordpress_lc.name}-asg"

  min_size = 1
  desired_capacity = 2
  max_size = 5
#   availability_zones = ["us-east-1e", "us-east-1f"]
  launch_configuration = aws_launch_configuration.wordpress_lc.name
  vpc_zone_identifier  = [var.vpc_zone_identifier]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "wordpresselb" {
  name = "wordpresselb"
  subnets = [var.subnets]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:8000/"
    interval = 30
  }

  instances = [var.instances]
  cross_zone_load_balancing = true
#   idle_timeout = 400
#   connection_draining = true
#   connection_draining_timeout = 400

  tags = {
    Name = "wordpresselb"
  }
}


