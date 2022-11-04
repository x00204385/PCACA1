locals {
  public_subnets  = [aws_subnet.public-subnet-1a.id, aws_subnet.public-subnet-1b.id]
  private_subnets = [aws_subnet.private-subnet-1a.id, aws_subnet.private-subnet-1b.id]
  servers         = ["s1", "s2"]
}

resource "aws_instance" "webinstance" {
  count                  = length(local.public_subnets)
  ami                    = var.instance-ami
  instance_type          = "t2.micro"
  subnet_id              = element(local.public_subnets, count.index)
  key_name               = "tud-aws"
  vpc_security_group_ids = [aws_security_group.allow-ssh.id, aws_security_group.allow-http.id]

  tags = {
    Name = "bastion-instance"
  }

  user_data = <<-EOF
                  #!/bin/bash
                  sudo su
                  yum -y install httpd
                  yum -y install lynx
                  echo "<p> My app server ${count.index+1}</p>" >> /var/www/html/index.html
                  sudo systemctl enable httpd
                  sudo systemctl start httpd
                  EOF

}


resource "aws_instance" "private-instance" {
  count         = length(local.private_subnets)
  ami           = var.instance-ami
  instance_type = "t2.micro"

  subnet_id = element(local.private_subnets, count.index)

  vpc_security_group_ids = [aws_security_group.allow-ssh.id]

  key_name = "tud-aws"

  tags = {
    Name = "private-instance"
  }
}

resource "aws_lb_target_group" "pcaca1-LB" {
  name     = "pcaca1-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
    tags = {
    Name = "pcaca1-TG"
  }

}

resource "aws_lb_target_group_attachment" "pcaca1-attach" {
  count = length(aws_instance.webinstance)
  target_group_arn = aws_lb_target_group.pcaca1-TG.arn
  target_id = aws_instance.webinstance[count.index].id
  port = 80
}

resource "aws_lb_listener" "pcaca1-Listener" {
  load_balancer_arn = aws_lb.pcaca1-TG.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pcaca1-TG.arn
  }
}


resource "aws_lb" "pcaca1-TG" {
  name               = "pcaca1-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow-http.id]
  subnets            = [aws_subnet.public-subnet-1a.id, aws_subnet.public-subnet-1b.id]

  enable_deletion_protection = false

  tags = {
    Name = "pcaca1-LB"
  }
}
