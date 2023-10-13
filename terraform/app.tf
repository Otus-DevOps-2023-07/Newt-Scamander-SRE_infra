######
resource "yandex_compute_instance" "app" {
  #first symbol - a letter, letters,number and "-" only!
  name   = "reddit-app-${formatdate("YYYY-MM-DD-HH-mm", timestamp())}"
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
      image_id = var.app_disk_image_id
    }
  }

  network_interface {
    # Set the subnet id in your zone (default: ru-central1-a)
    # subnet_id = var.subnet_id #use with variable
    subnet_id = "${yandex_vpc_subnet.aplications-subnet.id}" #use with current subnet_id
    nat       = true

  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
    user-data = <<-EOF
                  #!/bin/bash
                  echo "DATABASE_URL=${yandex_compute_instance.db.network_interface.0.nat_ip_address}:27017" >> /etc/environment
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

  provisioner "file" {
    content     = templatefile("./files/puma.service", { DB_connection = var.DB_connection_address })
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "./files/deploy.sh"
  }

}
