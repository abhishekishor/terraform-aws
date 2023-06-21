data "aws_ami" "amazonlinux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"]

}

resource "aws_security_group" "public" {
  name        = "${var.env_code}-public"
  description = "Allow public traffics"
  vpc_id      = data.terraform_remote_state.level1.outputs.vpc_id



  ingress {
    description = "HTTPD from Home Office"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["49.37.66.135/32"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "${var.env_code}-public"
  }

}

resource "aws_instance" "public" {
  ami                         = data.aws_ami.amazonlinux.id
  instance_type               = "t3.micro"
  subnet_id                   = data.terraform_remote_state.level1.outputs.public_subnet_id[0]
  vpc_security_group_ids      = [aws_security_group.public.id]
  key_name                    = "practise"
  associate_public_ip_address = true

  tags = {
    name = "${var.env_code}-public"
  }
}


resource "aws_security_group" "private" {
  name        = "${var.env_code}-private"
  description = "Allow private traffics"
  vpc_id      = data.terraform_remote_state.level1.outputs.vpc_id

  ingress {
    description     = "HTTPD from Home Load-balancer"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.load_balancer.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "${var.env_code}-private"
  }

}

