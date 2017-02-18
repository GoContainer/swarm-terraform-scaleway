provider "scaleway" {
  token = "${var.scw_token}"
  organization = "${var.scw_organization}"

  region = "${var.scw_region}"
}

data "scaleway_image" "docker" {
  architecture = "x86_64"
  name = "Docker"
}

resource "scaleway_server" "swarm_manager" {
  name  = "swarm_manager"
  image = "${data.scaleway_image.docker.id}"
  type  = "${var.scw_type_manager}"
  dynamic_ip_required = true

  connection {
    user     = "${var.scw_machine_user}"
    private_key = "${file("${var.scw_ssh_key}")}"
    agent = false
  }

  provisioner "remote-exec" {
    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      "apt update",
      "apt upgrade -o Dpkg::Options::='--force-confold' --force-yes -y",
      "docker swarm  init",
      "docker swarm join-token -q worker >> /tmp/swarm.token"
    ]
  }

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${var.scw_ssh_key} ${var.scw_machine_user}@${scaleway_server.swarm_manager.public_ip}:/tmp/swarm.token ."
  }
}

resource "scaleway_server" "swarm_node" {
  name  = "swarm_node-${count.index + 1}"
  image = "${data.scaleway_image.docker.id}"
  type  = "${var.scw_type_node}"
  count = "${var.swarm_nodes}"
  dynamic_ip_required = true

  connection {
    user     = "${var.scw_machine_user}"
    private_key = "${file("${var.scw_ssh_key}")}"
    agent = false
  }

  provisioner "file" {
    source = "swarm.token"
    destination = "/tmp/node.token"
  }

  provisioner "remote-exec" {
    inline = [
      "docker swarm join --token $(cat /tmp/node.token) ${scaleway_server.swarm_manager.private_ip}:2377"
    ]
  }
}
