output "cluster_node_swarm" {
  value = "${join("\n", scaleway_server.swarm_node.*.public_ip)}"
}

output "cluster_master_swarm" {
  value = "${join("\n", scaleway_server.swarm_manager.public_ip)}"
}