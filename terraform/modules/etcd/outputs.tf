output "etcd_clients" {
  value = "${join(",", formatlist("%s:%s", aws_instance.etcd.*.private_ip, "2379"))}"
}
