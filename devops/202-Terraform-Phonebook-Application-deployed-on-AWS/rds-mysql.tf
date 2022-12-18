resource "aws_db_instance" "mysql-db" {
  allocated_storage    = 10
  db_name              = "phonebook"
  engine               = "mysql"
  engine_version       = "8.0.19"
  instance_class       = "db.t2.micro"
  username             = "admin"
  password             = "Polat_1"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}