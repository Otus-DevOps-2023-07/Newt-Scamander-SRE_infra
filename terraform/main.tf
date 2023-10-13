terraform {
  required_version = ">=1.4.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.90.0"
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
resource "time_static" "example" {}
