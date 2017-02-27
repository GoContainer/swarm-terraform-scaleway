output "cluster_swarm" {
  value = "${join("\n", scaleway_server.swarm_node.*.public_ip)}"
}