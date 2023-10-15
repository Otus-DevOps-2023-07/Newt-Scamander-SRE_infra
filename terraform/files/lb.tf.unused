resource "yandex_lb_target_group" "lb-target-group" {
  name      = "temp-app-lb-target-group"
  region_id = "ru-central1"

  dynamic "target" {
    for_each = yandex_compute_instance.app.*.network_interface.0.ip_address
    content {
      subnet_id = var.subnet_id
      address   = target.value
    }
  }
}


resource "yandex_lb_network_load_balancer" "yc-balancer" {
  name = "app-reddit-yc-balancer"

  listener {
    name        = "temp-app-listener"
    port        = "8080"
    target_port = "9292"
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = yandex_lb_target_group.lb-target-group.id

    healthcheck {
      name                = "http"
      interval            = 4
      timeout             = 1
      unhealthy_threshold = 2
      healthy_threshold   = 2
      tcp_options {
        port = 9292
        # path = "/ping" #for http_options only!
      }
    }
  }
}
