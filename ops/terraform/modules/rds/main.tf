
resource "aws_rds_cluster_instance" "cluster_instance" {
  count                = 1
  identifier           = "${var.project_name}-${count.index}"
  cluster_identifier   = aws_rds_cluster.postgresql.id
  instance_class       = "db.t3.medium"
  engine               = aws_rds_cluster.postgresql.engine
  engine_version       = aws_rds_cluster.postgresql.engine_version
  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.main.name
}

resource "aws_rds_cluster" "postgresql" {
  cluster_identifier      = "${var.project_name}-aurora-cluster"
  engine                  = "aurora-postgresql"
  engine_mode             = "provisioned"
  availability_zones      = var.azs
  database_name           = "mydb"
  master_username         = "foo"
  master_password         = "must_be_eight_characters"
  backup_retention_period = 7
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.aurora_sg.id]
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}"
  subnet_ids = var.db_subnets_ids

  tags = {
    Name = "${var.project_name}-DB subnet group"
  }
}

resource "aws_security_group" "aurora_sg" {
  vpc_id = var.vpc_id
  name   = "aurora-sg"

  ingress {
    from_port   = 5432 # Or 5432 for PostgreSQL
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.private_subnets_cidrs # Restrict this in production
    security_groups = [var.private_security_group_id]
  }
}
