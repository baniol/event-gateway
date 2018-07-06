output "config_url" {
  description = "Event Gateway Config API URL"
  value       = "${module.alb-config.dns_name}"
}

output "events_url" {
  description = "Event Gateway Events API URL"
  value       = "${module.alb-events.dns_name}"
}
