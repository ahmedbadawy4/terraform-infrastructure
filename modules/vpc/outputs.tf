output "main_subnet1_id" {
  value       = ["${aws_subnet.subnet_1.id}"]
  description = "eks subnet 1 id"
}

output "sg_worker_id" {
  value = "${aws_security_group.worker-node.id}"
}

output "default_subnet_group_id" {
  value = "${aws_db_subnet_group.eks.id}"
}
output "subnet2_id" {
  value = "${aws_subnet.subnet_2.id}"
  description = "eks subnet 2 id"
}

output "SUBNET_IDS" {
  value = ["${aws_subnet.subnet_1.id}", "${aws_subnet.subnet_2.id}"]
  description = "eks subnet  ids"
}
