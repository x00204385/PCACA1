
resource "aws_instance" "bastion-instance-1a" {
  ami           = var.instance-ami
  instance_type = "t2.micro"

  subnet_id = aws_subnet.public-subnet-1a.id

  vpc_security_group_ids = [aws_security_group.allow-ssh.id, aws_security_group.allow-http.id]

  key_name = "tud-aws"

  tags = {
    Name = "bastion-instance-1a"
  }

  user_data     = <<-EOF
                  #!/bin/bash
                  sudo su
                  yum -y install httpd
                  echo "<p> My Instance 1</p>" >> /var/www/html/index.html
                  sudo systemctl enable httpd
                  sudo systemctl start httpd
                  EOF
}
output "my-public-ip-1a"{
       value= aws_instance.bastion-instance-1a.public_ip
}

resource "aws_instance" "bastion-instance-1b" {
  ami           = var.instance-ami
  instance_type = "t2.micro"

  subnet_id = aws_subnet.public-subnet-1b.id

  vpc_security_group_ids = [aws_security_group.allow-ssh.id, aws_security_group.allow-http.id]

  key_name = "tud-aws"

  tags = {
    Name = "bastion-instance-1b"
  }

  user_data     = <<-EOF
                  #!/bin/bash
                  sudo su
                  yum -y install httpd
                  echo "<p> My Instance 1</p>" >> /var/www/html/index.html
                  sudo systemctl enable httpd
                  sudo systemctl start httpd
                  EOF
}
output "my-public-ip-1b"{
       value= aws_instance.bastion-instance-1b.public_ip
}


resource "aws_instance" "private-instance" {
  ami           = var.instance-ami
  instance_type = "t2.micro"

  subnet_id = aws_subnet.private-subnet-1a.id

  vpc_security_group_ids = [aws_security_group.allow-ssh.id]

  key_name = "tud-aws"
  
  tags = {
    Name = "private-instance"
  }
}
