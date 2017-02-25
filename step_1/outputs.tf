output "Docker Swarm Manager(s) Public IPs" {
  value = "${join("\n               ", formatlist("%s", split(",", scaleway_server.swarm_manager.public_ip)))}"
}