output "practice_vpc" {
  value = aws_vpc.custom_vpc.id
}

output "practice_subnet"{
  value = aws_subnet.custom_subnet.id
}