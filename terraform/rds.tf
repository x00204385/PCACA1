resource "aws_db_subnet_group" "pcaca1-db-subnetgroup" {
  name       = "pcaca1-db-subnetgroup"
  subnet_ids = [aws_subnet.public-subnet-1a.id, aws_subnet.public-subnet-1b.id]

  tags = {
    Name = "PCACA1 DB subnet group"
  }
}


# Create MySQL RDS instance
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
#
resource "aws_db_instance" "pcaca1-rds" {
  allocated_storage    = 20
  db_name              = "mysqldatabase"
#  db_instance_identifier = "mysqldatabase"
  engine               = "mysql"
  engine_version       = "8.0"
  storage_type         = "gp2"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_password
  skip_final_snapshot  = true
  db_subnet_group_name = "pcaca1-db-subnetgroup"
}


