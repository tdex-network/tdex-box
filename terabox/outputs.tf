# output "address" {
#   value = aws_elb.web.dns_name
# }
output "ec2_global_ips" {
  value = ["${aws_instance.web.*.public_ip}"]
}