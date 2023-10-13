# output "external_ip_address_app" {
#   value = yandex_compute_instance.app.network_interface.0.nat_ip_address
# }

# output "external_ip_addresses" {
#   value = {
#     for instance_name, instance in yandex_compute_instance.app : instance_name => instance.network_interface[0].nat_ip_address
#   }
# }

output "external_ip_address_app" {
  value =  module.app.external_ip_address_app
}

output "internal_ip_address_app" {
  value = module.app.internal_ip_address_app
}

output "external_ip_address_db" {
  value = module.db.external_ip_address_db
}
output "internal_ip_address_db" {
  value = module.db.internal_ip_address_db
}

# # uncomment only for configuration with loadbalancer
# output "external_lb_ip_address" {
#   value = yandex_lb_network_load_balancer.yc-balancer.listener.*.external_address_spec[0].*.address
# }


output "current_time" {
  value = time_static.example.rfc3339
}
