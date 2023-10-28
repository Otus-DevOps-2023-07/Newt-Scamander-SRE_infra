terraform {
  required_version = ">=1.4.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.95"
    }

    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}
######
resource "yandex_compute_instance" "app" {
  #first symbol - a letter, letters,number and "-" only!
  name = "reddit-app-${formatdate("YYYY-MM-DD-HH-mm", timestamp())}"
  description = "http://web_app_IP:port"

  ######
  resources {
    cores         = 2
    core_fraction = 20
    memory        = 4
  }

  boot_disk {
    initialize_params {
      # Set the IMAGE id of "golden image", created before
      image_id = var.app_disk_image
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys  = "ubuntu:${file(var.public_key_path)}"
    user-data = <<-EOF
                #!/bin/bash
                echo "DATABASE_URL=${var.DB_connection}:27017" >> /etc/environment
                EOF
  }
  ########

  connection {
    type  = "ssh"
    host  = self.network_interface.0.nat_ip_address #Be attention - self use!
    user  = "ubuntu"
    agent = true # <true> when private key doesn't store at ~/.ssh/ and use keepass (for example). <false> - If you should set private key
    #private_key = file("~/.ssh/ya-cloud-otus-key") #used usually
  }

  ## temporary disabled for HW Ansible_2

  # provisioner "file" {
  #   source      = "${path.module}/files/puma.service"
  #   destination = "/tmp/puma.service"
  # }

  # provisioner "remote-exec" {
  #   script = "${path.module}/files/deploy.sh"
  # }

}
