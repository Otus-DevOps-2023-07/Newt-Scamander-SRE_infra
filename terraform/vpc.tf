######
resource "yandex_vpc_network" "aplications-network" {
  name = "aplications-network"
  }

######
resource "yandex_vpc_subnet" "aplications-subnet" {
  name = "aplications-subnet"
  zone = var.zone
  network_id = "${yandex_vpc_network.aplications-network.id}"
  v4_cidr_blocks = ["192.168.10.0/24"]
}
