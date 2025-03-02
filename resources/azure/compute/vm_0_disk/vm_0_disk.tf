/*
    Manages a Linux Virtual Machine.
*/

variable "vm_count" {}
variable "vm_name_prefix" {}
variable "image_publisher" {}
variable "image_offer" {}
variable "image_sku" {}
variable "image_version" {}
variable "resource_group_name" {}
variable "location" {}
variable "vm_size" {}
variable "subnet_ids" {}
variable "login_username" {}
variable "proximity_placement_group_id" {}
variable "os_diff_disk" {}
variable "os_disk_caching" {}
variable "os_storage_account_type" {}
variable "user_public_key" {}
variable "meta_private_key" {}
variable "meta_public_key" {}
variable "dns_zone" {}
variable "vnet_availability_zones" {}

data "template_file" "user_data" {
  template = <<EOF
#!/usr/bin/env bash
echo "${var.meta_private_key}" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
echo "${var.meta_public_key}" >> ~/.ssh/authorized_keys
echo "StrictHostKeyChecking no" >> ~/.ssh/config
if grep -q "Red Hat" /etc/os-release
then
    yum install -y jq python3 kernel-devel-$(uname -r) kernel-headers-$(uname -r)
fi
echo "DOMAIN=\"${var.dns_zone}\"" >> "/etc/sysconfig/network-scripts/ifcfg-eth0"
systemctl restart NetworkManager
EOF
}

data "template_cloudinit_config" "user_data64" {
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.user_data.rendered
  }
}

resource "azurerm_network_interface" "itself" {
  for_each = {
    for idx, count_number in range(1, var.vm_count + 1) : idx => {
      sequence_string = tostring(count_number)
      subnet_id       = element(var.subnet_ids, idx)
    }
  }

  name                = format("%s-%s", var.vm_name_prefix, each.value.sequence_string)
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = format("%s-%s", var.vm_name_prefix, each.value.sequence_string)
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_private_dns_a_record" "itself" {
  for_each = {
    for idx, count_number in range(1, var.vm_count + 1) : idx => {
      sequence_string = tostring(count_number)
      network_ip      = element(tolist([for ip_details in azurerm_network_interface.itself : ip_details.private_ip_address]), idx)
    }
  }

  name                = format("%s-%s", var.vm_name_prefix, each.value.sequence_string)
  zone_name           = var.dns_zone
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [each.value.network_ip]

  depends_on = [azurerm_network_interface.itself]
}

resource "azurerm_linux_virtual_machine" "itself" {
  for_each = {
    # This assigns a network_interface_id to each of the instance
    # iteration.
    for idx, count_number in range(1, var.vm_count + 1) : idx => {
      sequence_string      = tostring(count_number)
      network_interface_id = element(tolist([for nic_details in azurerm_network_interface.itself : nic_details.id]), idx)
      zone_id              = length(var.vnet_availability_zones) > 1 ? ((idx % 3) + 1) : "1"
    }
  }

  name                         = format("%s-%s", var.vm_name_prefix, each.value.sequence_string)
  resource_group_name          = var.resource_group_name
  location                     = var.location
  size                         = var.vm_size
  admin_username               = var.login_username
  network_interface_ids        = [each.value.network_interface_id]
  proximity_placement_group_id = var.proximity_placement_group_id
  zone                         = each.value.zone_id

  admin_ssh_key {
    username   = var.login_username
    public_key = file(var.user_public_key)
  }

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_storage_account_type
    diff_disk_settings {
      option    = "Local"
      placement = var.os_diff_disk
    }
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  custom_data = data.template_cloudinit_config.user_data64.rendered
}

output "instance_private_ips" {
  value = try(toset([for instance_details in azurerm_linux_virtual_machine.itself : instance_details.private_ip_address]), [])
}

output "instance_ids" {
  value = try(toset([for instance_details in azurerm_linux_virtual_machine.itself : instance_details.id]), [])
}
