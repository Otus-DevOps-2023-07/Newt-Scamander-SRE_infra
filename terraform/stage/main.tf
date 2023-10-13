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

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}
module "app" {
  source          = "../modules/app"
  public_key_path = var.public_key_path
  app_disk_image  = var.app_disk_image_id
  subnet_id       = var.subnet_id
  DB_connection   = module.db.external_ip_address_db
}

module "db" {
  source          = "../modules/db"
  public_key_path = var.public_key_path
  db_disk_image   = var.db_disk_image_id
  subnet_id       = var.subnet_id
}


resource "time_static" "example" {}
