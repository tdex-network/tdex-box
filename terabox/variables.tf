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
  default = "REGION"
}
variable "aws_access_key" {
  description = "AWS access key to launch servers."
  default = "AWS_ACCESS"
}
variable "aws_secret_key" {
  description = "AWS secret to launch servers."
  default = "AWS_SECRET"
}

# Ubuntu Precise 18.04 LTS (x64)
variable "aws_amis" {
  default = {
    REGION = "AMI_ID"
  }
}

variable "instance_count" {
  default = "1"
}