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
                  echo "<p> My app server ${count.index + 1}</p>" >> /var/www/html/index.html
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


