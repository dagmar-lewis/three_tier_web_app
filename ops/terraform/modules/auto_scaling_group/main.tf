resource "aws_launch_template" "public" {
  name_prefix   = var.project_name
  image_id      = var.ami
  instance_type = var.instance_type
  user_data     = filebase64("../../../scripts/public_launch_template.sh")
  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 30
    }
  }

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.public-instance.id, aws_security_group.ssh.id]
  }
}

resource "aws_launch_template" "private" {
  name_prefix   = var.project_name
  image_id      = var.ami
  instance_type = var.instance_type
  user_data     = filebase64("../../../scripts/private_launch_template.sh")
  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 30
    }
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.private-instance.id]
  }

}

resource "aws_autoscaling_group" "public" {
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = var.public_subnets_ids
  target_group_arns   = [aws_lb_target_group.public.arn]


  launch_template {
    id      = aws_launch_template.public.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_group" "private" {
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = var.private_subnets_ids
  target_group_arns   = [aws_lb_target_group.private.arn]

  launch_template {
    id      = aws_launch_template.private.id
    version = "$Latest"
  }
}

resource "aws_lb" "public" {
  name               = "${var.project_name}-public-lb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.public_subnets_ids

  enable_deletion_protection = false
  security_groups            = [aws_security_group.public-lb.id]
  tags = {
    Name = "${var.project_name}"
  }
}

resource "aws_lb" "private" {
  name                       = "${var.project_name}-private-lb"
  internal                   = true
  load_balancer_type         = "network"
  subnets                    = var.private_subnets_ids
  security_groups            = [aws_security_group.private-lb.id]
  enable_deletion_protection = false

  tags = {
    Name = "${var.project_name}"
  }
}

resource "aws_lb_listener" "public" {
  load_balancer_arn = aws_lb.public.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public.arn
  }
}

resource "aws_lb_listener" "private" {
  load_balancer_arn = aws_lb.private.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private.arn
  }
}

resource "aws_lb_target_group" "public" {
  name        = "${var.project_name}-public-tg"
  port        = 8080
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = var.vpc_id

}

resource "aws_lb_target_group" "private" {
  name        = "${var.project_name}-private-tg"
  port        = 8080
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = var.vpc_id

}


resource "aws_security_group" "public-lb" {
  name   = "${var.project_name}-public-lb-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private-lb" {
  name   = "${var.project_name}-ptivate-lb-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.public-instance.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "public-instance" {
  name   = "${var.project_name}-public-instance-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.public-lb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}

resource "aws_security_group" "private-instance" {
  name   = "${var.project_name}-private-instance-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.private-lb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}

resource "aws_security_group" "ssh" {
  vpc_id = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # For demo purposes only - restrict this in production
  }
}


resource "aws_autoscaling_attachment" "public" {
  autoscaling_group_name = aws_autoscaling_group.public.id
  lb_target_group_arn    = aws_lb_target_group.public.arn
}

resource "aws_autoscaling_attachment" "private" {
  autoscaling_group_name = aws_autoscaling_group.private.id
  lb_target_group_arn    = aws_lb_target_group.private.arn
}

