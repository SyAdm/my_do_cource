terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.177.0"
    }
  }
}

locals {
  folder_id = "ao7lit6t1mj5d993qr3f"
  cloud_id  = "ao7atqlutanc127uolem"
}

provider "yandex" {
  # Configuration options
  endpoint                 = "api.yandexcloud.kz:443"
  cloud_id                 = local.cloud_id
  folder_id                = local.folder_id
  service_account_key_file = "/home/sherali/s.json"
  zone                     = "kz1-a"
}

variable "number_of_vms" {
  description = "Сколько ВМ создать"
  type        = number
  default     = 3
}

# Всё остальное создается автоматически
resource "yandex_vpc_network" "network-1" {
  name = "tf-network"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "tf-subnet"
  zone           = "kz1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_compute_disk" "boot-disk" {
  count = var.number_of_vms

  name     = "tf-disk-${count.index + 1}"
  type     = "network-hdd"
  zone     = "kz1-a"
  size     = "20"
  image_id = "fbnhbfcbpi8unonvqnfr"
}

resource "yandex_compute_instance" "vm" {
  count = var.number_of_vms

  name = "tf-vm-${count.index + 1}"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk[count.index].id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "sherali:${file("~/.ssh/id_ed25519.pub")}"
  }
}

output "summary" {
  value = <<-EOT
  Создано ${var.number_of_vms} виртуальных машин:
  
  ${join("\n  ", [for idx, vm in yandex_compute_instance.vm : "${vm.name}: внешний IP ${vm.network_interface[0].nat_ip_address}, внутренний IP ${vm.network_interface[0].ip_address}"])}
  EOT
}
