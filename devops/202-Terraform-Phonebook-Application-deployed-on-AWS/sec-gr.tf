resource "aws_security_group" "alb-sg" {
  name        = "alb-sg"
  description = "Allow 80 inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg-80"
  }
  
}
resource "aws_security_group" "instances-sg" {
  name        = "instances-sg"
  description = "Allow 80 inbound traffic from ALB"
  vpc_id      = "vpc-0bde5a6bb06a5cb93"

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instances-sg-80-from-alb"
  }
}

# Code below may need to be added to instances-sg as ingress!
resource "aws_security_group" "rds-sg" {
  name        = "rds-sg"
  description = "Allow rds inbound traffic"
  vpc_id      = "vpc-0bde5a6bb06a5cb93"

  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups = [aws_security_group.instances-sg.id]
  }

  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instances-sg-80-from-alb"
  }
}