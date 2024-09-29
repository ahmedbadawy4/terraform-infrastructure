resource "aws_security_group" "atlantis_sg" {
  name        = "atlantis_sg"
  description = "Allow HTTP/HTTPS traffic for Atlantis"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.sg_cidr_blocks
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.sg_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.sg_cidr_blocks
  }
}

resource "aws_instance" "atlantis" {
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI
  instance_type = var.instance_type
  key_name      = var.ssh_key_name

  iam_instance_profile = aws_iam_instance_profile.atlantis_profile.name

  security_groups = [
    aws_security_group.atlantis_sg.name,
  ]

}
