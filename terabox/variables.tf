variable "public_key_path" {
  description = <<DESCRIPTION
Path to the SSH public key to be used for authentication.
Ensure this keypair is added to your local SSH agent so provisioners can
connect.

Example: ~/.ssh/terraform.pub
DESCRIPTION
}

variable "key_name" {
  description = "Desired name of AWS key pair"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default = "eu-west-1"
}
variable "aws_access_key" {
  description = "AWS access key to launch servers."
}
variable "aws_secret_key" {
  description = "AWS secret to launch servers."
}

# Ubuntu Precise 18.04 LTS (x64)
variable "aws_amis" {
  default = {
    eu-west-1 = "ami-0a8e758f5e873d1c1"
  }
}

variable "instance_count" {
  default = "1"
}