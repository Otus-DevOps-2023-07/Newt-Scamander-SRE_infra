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
resource "yandex_compute_instance" "db" {
  #first symbol - a letter, letters,number and "-" only!
  name = "reddit-db-${formatdate("YYYY-MM-DD-HH-mm", timestamp())}"

  ######
  resources {
    cores         = 2
    core_fraction = 20
    memory        = 4
  }

  boot_disk {
    initialize_params {
      # Set the IMAGE id of "golden image", created before
      image_id = var.db_disk_image
    }
  }
  #Disable external IP for VM with DB in prod!
  network_interface {
    subnet_id = var.subnet_id #use with variable
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
    #private_key = file("~/.ssh/ya-cloud-otus-key") #used usually
  }

  ########
  provisioner "remote-exec" {
    script = "${path.module}/files/db_deploy.sh"
  }

}
