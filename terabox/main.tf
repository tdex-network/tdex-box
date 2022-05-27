terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.aws_region
  # access_key = var.aws_access_key
  # secret_key = var.aws_access_key
}
resource "aws_vpc" "default" {
  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      cidr_block,
    ]
  }
  cidr_block = "172.31.0.0/16"
}
resource "aws_internet_gateway" "default" {
  lifecycle {
    prevent_destroy = true
  }
  vpc_id = aws_vpc.default.id
}
resource "aws_route" "internet_access" {
  lifecycle {
    prevent_destroy = true
  }
  route_table_id         = aws_vpc.default.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}
resource "aws_subnet" "default" {
  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      vpc_id,
      cidr_block,
    ]
  }
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "172.31.198.0/24"
  map_public_ip_on_launch = true
}
resource "aws_security_group" "default" {
  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      name,
      vpc_id,
    ]
  }
  name        = "terraform_example"
  description = "Used in the terraform"
  vpc_id      = aws_vpc.default.id

  # Whitelist desired IPs.
  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["172.31.198.0/24","222.222.222.222/32"]
  }
  ingress {
    from_port   = 9945
    to_port     = 9945
    protocol    = "tcp"
    cidr_blocks = ["172.31.198.0/24","222.222.222.222/32"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.31.198.0/24","222.222.222.222/32"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "auth" {
  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      key_name,
      public_key,
    ]
  }
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "web" {
  connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
    private_key = file(var.key_name)
    timeout     = "1m"
    agent       = false
  }
  count = var.instance_count
  instance_type = "t2.medium"
  ami = var.aws_amis[var.aws_region]
  key_name = aws_key_pair.auth.id
  vpc_security_group_ids = [aws_security_group.default.id]
  subnet_id = aws_subnet.default.id
  tags = {
    "type" = "tdex-box",
  }
  provisioner "file" {
  source      = "./scripts/provisioner.sh"
  destination = "/home/ubuntu/provisioner.sh"
  }
  provisioner "file" {
  source      = "./scripts/cronscript.sh"
  destination = "/home/ubuntu/cronscript.sh"
  }
  provisioner "file" {
  source      = "./scripts/backup.sh"
  destination = "/home/ubuntu/backup.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt -y update && sudo apt -y install git",
      "git clone https://github.com/TDex-network/tdex-box.git",
    ]
  }
  provisioner "file" {
  source      = "./docker-compose-tor.yml"
  destination = "/home/ubuntu/tdex-box/docker-compose-tor.yml"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt install -y apt-transport-https ca-certificates curl software-properties-common awscli curl dnsutils bsdmainutils",
      "curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh && sudo curl -L 'https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64' -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose && sudo usermod -a -G docker ubuntu",
      "chmod +x /home/ubuntu/provisioner.sh",
      "export IP=$(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'\"' '{ print $2}'); sed -i \"s,tdexd,$IP,g\" /home/ubuntu/tdex-box/feederd/config.json",
      "export IP=$(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'\"' '{ print $2}'); sed -i \"s,ServerIPAddr,$IP,g\" /home/ubuntu/provisioner.sh",
      "mkdir /home/ubuntu/tdex-box/tdexd/",
      "sudo /home/ubuntu/provisioner.sh",
      "chmod +x /home/ubuntu/cronscript.sh",
      "sudo bash /home/ubuntu/cronscript.sh",
      "chmod +x /home/ubuntu/backup.sh",
      "/usr/bin/hexdump -v -e ' 1/1 \"%02x\"' /home/ubuntu/tdex-box/tdexd/macaroons/admin.macaroon",
      "/usr/bin/cat /home/ubuntu/tdex-box/tdexd/tls/cert.pem"
    ]
  }
}
