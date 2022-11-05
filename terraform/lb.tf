resource "aws_lb_target_group" "pcaca1-TG" {
  name     = "pcaca1-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  tags = {
    Name = "pcaca1-TG"
  }

}

resource "aws_lb_target_group_attachment" "pcaca1-attach" {
  count            = length(aws_instance.webinstance)
  target_group_arn = aws_lb_target_group.pcaca1-TG.arn
  target_id        = aws_instance.webinstance[count.index].id
  port             = 80
}

resource "aws_lb_listener" "pcaca1-Listener" {
  load_balancer_arn = aws_lb.pcaca1-LB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pcaca1-TG.arn
  }
}


resource "aws_lb" "pcaca1-LB" {
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