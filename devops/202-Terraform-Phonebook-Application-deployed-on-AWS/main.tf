# Latest t2.micro ami is fetched [A-B] >>>>>
data "aws_ami" "amazon-linux-2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm*"]
  }
}

data "template_file" "userdata" {
  template = file("${abspath(path.module)}/userdata.sh") # Check the last terraform hands on userdata!
  vars = {
    server-name = var.server-name
  }
}
# Latest t2.micro ami is fetched [B-A] <<<<<



# Target group is created [C-D] >>>>>
resource "aws_lb_target_group" "my-tg" {
  health_check {
    interval = 10
    path = "/"
    protocol = "HTTP"
    timeout = 5
    healthy_threshold = 5
    unhealthy_threshold = 2
  }
  name = "my-test-tf-tg"
  port = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = var.vpc_id
}
# Target group is created [D-C] <<<<<<


# IAM instance profile >>>>>>>>>
# resource "aws_iam_instance_profile" "iam-instance-profile" {
#   name = "iam-instance-profile"
#   roles = [""]
# }
# IAM instance profile <<<<<<<<<


# Launch Template is created [E-F] >>>>>>>>>>>>>>>>>>>>>
resource "aws_launch_template" "my-tf-lt" {
  name = "my-tf-lt"

#   iam_instance_profile {
#     name = "test"
#   }

  image_id = data.aws_ami.amazon-linux-2.image_id  # Analyz later ! ! !

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t2.micro"

  key_name = var.key_name

  monitoring {
    enabled = true
  }

  placement {
    availability_zone = ["us-east-1a, us-east-1b"] # use variable
  }

  vpc_security_group_ids = var.aws_security_group.instances-sg.id # Istances will get this sg

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Web Server of Phonebook App"
    }
  }

  user_data = filebase64("${path.module}/userdata.sh")
}
# Launch Template is created [F-E] <<<<<<<<<<<<<<<<<<<<<<<<


resource "aws_internet_gateway" "internet_gateway" {
  vpc_id =  var.default_vpc_id
  tags = {
    Name = "flask-tf-igw"
  }
}

###############################
# Code below might be needed 
# provisioner "local-exec" {
#   command = "echo http://${self.public_ip} > public_ip.txt"
# }

# # Code below might be needed
# connection {
#   host = self.public_ip
#   type = "ssh"
#   user = "ec2-user"
#   private_key = file("~/firstkey.pem")
# }

