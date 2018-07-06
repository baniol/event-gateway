module "event-gateway" {
  source = "terraform"

  command_list = ["-dev", "-log-level", "debug"]

  tags = {
    Application = "event-gateway"
  }
}

output "config_url" {
  value = "${module.event-gateway.config_url}"
}

output "events_url" {
  value = "${module.event-gateway.events_url}"
}
