# Create DB subnet group
resource "aws_db_subnet_group" "database-subnet" {
  name = "database-subnet-group"
  subnet_ids = [var.private_data_subnet_az1_id,var.private_data_subnet_az2_id]
}

# Create MySQL resource

resource "aws_db_instance" "my_test_mysql" {
  allocated_storage           = var.allocated_storage
  storage_type                = var.storage_type
  engine                      = var.engine
  engine_version              = var.engine_version
  instance_class              = var.instance_class
  name                        = "${var.project_name}db"
  username                    = var.username
  password                    = var.password
  db_subnet_group_name        = aws_db_subnet_group.database-subnet.name
  vpc_security_group_ids      = [var.rds_security_group_id]
  multi_az                    = var.multi_az
  skip_final_snapshot         = var.skip_final_snapshot
}
