output "config_url" {
  description = "Event Gateway Config API URL"
  value       = "${aws_lb.config.dns_name}"
}

output "events_url" {
  description = "Event Gateway Events API URL"
  value       = "${aws_lb.events.dns_name}"
}
