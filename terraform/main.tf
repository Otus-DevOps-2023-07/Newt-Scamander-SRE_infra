# terraform {
#   required_version = ">=1.4.0"

#   required_providers {
#     yandex = {
#       source  = "yandex-cloud/yandex"
#       version = "0.90.0"
#     }

#     time = {
#       source  = "hashicorp/time"
#       version = "0.9.1"
#     }


#   }
# }

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

######
resource "time_static" "example" {}

resource "yandex_compute_instance" "app" {
  count  = var.instance_count
  name   = "${count.index + 1}-reddit-tmp-${formatdate("YYYY-MM-DD-HH-mm", timestamp())}"
  labels = var.initial_labels

  ######
  resources {
    cores         = 2
    core_fraction = 20
    memory        = 4
  }

  boot_disk {
    initialize_params {
      # Set the IMAGE id of "golden image", created before
      image_id = var.image_id
    }
  }

  network_interface {
    # Set the subnet id in your zone (default: ru-central1-a)
    subnet_id = var.subnet_id
    nat       = true

  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
  ########

  connection {
    type  = "ssh"
    host  = self.network_interface.0.nat_ip_address #Be attention - self use!
    user  = "ubuntu"
    agent = true # <true> when private key doesn't store at ~/.ssh/ and use keepass (for example). <false> - If you should set private key
    #private_key = file("~/.ssh/ya-cloud-otus-key")
  }

  # provisioner "file" {
  #   source      = "files/puma.service"
  #   destination = "/tmp/puma.service"
  # }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

provider "time" {
  # Configuration options
}
