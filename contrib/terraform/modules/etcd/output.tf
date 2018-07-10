output "bastion_ip" {
  value = "${element(concat(aws_instance.bastion.*.private_ip, list("")), 0)}"
}
