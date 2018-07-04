resource "aws_route53_zone" etcd {
  name   = "${var.cluster_domain}"
  vpc_id = "${var.vpc_id}"
}

resource "aws_route53_record" "etcd_srv_discover" {
  name    = "_etcd-server._tcp"
  type    = "SRV"
  zone_id = "${aws_route53_zone.etcd.id}"
  records = ["${formatlist("0 0 2380 %s", aws_route53_record.etc_a_nodes.*.fqdn)}"]
  ttl     = "300"
}

resource "aws_route53_record" "etcd_srv_client" {
  name    = "_etcd-client._tcp"
  type    = "SRV"
  zone_id = "${aws_route53_zone.etcd.id}"
  records = ["${formatlist("0 0 2379 %s", aws_route53_record.etc_a_nodes.*.fqdn)}"]
  ttl     = "300"
}

resource "aws_route53_record" "etc_a_nodes" {
  count   = "${var.etcd_count}"
  type    = "A"
  ttl     = 300
  zone_id = "${aws_route53_zone.etcd.id}"
  name    = "node-${count.index}"
  records = ["${aws_instance.etcd.*.private_ip[count.index]}"]
}
