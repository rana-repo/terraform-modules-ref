# create security group for the application load balancer
resource "aws_security_group" "alb_security_group" {
  name        = "alb security group"
  description = "enable http/https access on port 80/443"
  vpc_id      = var.vpc_id

  ingress {
    description      = "http access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "https access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "alb security group"
  }
}

# create security group for the container
resource "aws_security_group" "ecs_security_group" {
  name        = "ecs security group"
  description = "enable http/https access on port 80/443 via alb sg"
  vpc_id      = var.vpc_id

  ingress {
    description      = "http access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.alb_security_group.id]
  }

  ingress {
    description      = "https access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    security_groups  = [aws_security_group.alb_security_group.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "ecs security group"
  }
}

# Create a Security Group to allow mysql port 3306
resource "aws_security_group" "rds-sg" {
  name   = "my-rds-sg"
  description = "to allow mysql port 3306"
  vpc_id = var.vpc_id

ingress {
  from_port         = 3306
  protocol          = "tcp"
  to_port           = 3306
  cidr_blocks       = ["0.0.0.0/0"]
}
tags   = {
    Name = "database security group"
  }
}

# Create a security group to allow efs outbound

resource "aws_security_group" "webserver_sg" {
  name        = "webserver security group"
  description = "Allow efs outbound traffic"
  vpc_id      = var.vpc_id
  ingress {
     cidr_blocks = ["0.0.0.0/0"]
     from_port = 22
     to_port = 22
     protocol = "tcp"
   }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "webserver security group"
  }
}

# Create a security group to allow efs inbound

resource "aws_security_group" "efs" {
   name = "efs security group"
   description= "Allows inbound efs traffic from ec2"
   vpc_id = var.vpc_id

   ingress {
     security_groups = [aws_security_group.webserver_sg.id]
     from_port = 2049
     to_port = 2049 
     protocol = "tcp"
   }     
        
   egress {
     security_groups = [aws_security_group.webserver_sg.id]
     from_port = 0
     to_port = 0
     protocol = "-1"
   }
 }