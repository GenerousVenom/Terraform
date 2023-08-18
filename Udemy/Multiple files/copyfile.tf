resource "null_resource" "tf-addfile" {
  count = var.number_of_machines

#* Copy html file
  provisioner "file" {
    source = "Default.html"
    destination = "/var/www/html/Default.html"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt install snapd",
      "sudo snap install multipass"
    ]
  }

#* Copy multipass file
  provisioner "file" {
    source = "multipass.sh"
    destination = "/home/adminuser/multipass.sh"
  }

#* Copy ssh key pair file
  provisioner "file" {
    source = "id_rsa.pub"
    destination = "/home/adminuser/.ssh/id_rsa.pub"
  }

  connection {
    type = "ssh"
    user = "adminuser"
    private_key = file("linuxkey.pem")
#    private_key = file("${local_file.tf-linuxpemkey.filename}")
    host = "${azurerm_public_ip.tf-linuxpublicip[count.index].ip_address}"
  }

  depends_on = [
    local_file.tf-linuxpemkey,
    azurerm_linux_virtual_machine.tf-linuxvm
  ]
}

output "tf_copyfile_output" {
  value = "Copy files"
}