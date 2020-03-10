resource "aws_security_group" "common_sg" {
  name = "security-group-${var.region_code}-${var.env}-${var.groupname}-group-${var.instance_name}"
  vpc_id = var.vpc_id
  description = "${var.instance_name} Security Group"

  tags = {
        Name = "security-group-${var.region_code}-${var.env}-${var.groupname}-group-${var.instance_name}"
    }
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.common_sg.id
}

resource "aws_security_group_rule" "ingress" {
  count             = length(compact(var.allowed_ports))
  type              = "ingress"
  from_port         = var.allowed_ports[count.index]
  to_port           = var.allowed_ports[count.index]
  protocol          = "tcp"
  cidr_blocks       = var.whitelisted_ip
  security_group_id = aws_security_group.common_sg.id
}