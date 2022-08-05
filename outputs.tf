##### OUTPUTS ######


output "vpc_id" {
  value = aws_vpc.demo_vpc.id
}

output "elastic_ip" {
  value = aws_eip.demo_eip.id
}

output "instance1_public_ip" {
  value = aws_instance.demo_instance1.public_ip
}

output "instance1-private_ip" {
  value = aws_instance.demo_instance1.private_ip
}

output "instance2-private_ip" {
  value = aws_instance.demo_instance2.private_ip
}
