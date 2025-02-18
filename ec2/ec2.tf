

# resource "aws_key_pair" "deployer" {
#   key_name   = "deployer-key"
#   public_key = var.EC2Key
# }

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer" {

 
  key_name   = "aws_keys_pairs"

  # Public Key: The public will be generated using the reference of tls_private_key.terrafrom_generated_private_key
  public_key = tls_private_key.private_key.public_key_openssh

  # Store private key :  Generate and save private key(aws_keys_pairs.pem) in current directory
  # provisioner "local-exec" {
  #   command = <<-EOT
  #     echo '${tls_private_key.terrafrom_generated_private_key.private_key_pem}' > aws_keys_pairs.pem
  #     chmod 400 aws_keys_pairs.pem
  #   EOT
  # }
}

# Security Group for EC2 and ALB
resource "aws_security_group" "web" {
  name = "web-sg-1"
  vpc_id = var.INFRA_VCP_ID

  # Allow HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH (optional, you may want to restrict this)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebSecurityGroup"
  }
}

# Fetch latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]  # Official Amazon AMIs

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# EC2 Instance
resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id             = var.INFRA_PUB_SUB_ID
  security_groups        = [aws_security_group.web.id]
  associate_public_ip_address = true
  key_name = aws_key_pair.deployer.key_name

  user_data = <<-EOF
              #!/bin/bash
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Hello from $(hostname)" > /var/www/html/index.html
              EOF

  tags = {
    Name = "WebInstance"
  }

  lifecycle {
    ignore_changes = [ security_groups , ami ]
  }
 
}

