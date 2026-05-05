output "minecraft_server_ip" {
  description = "Dirección IP pública para conectarse al servidor"
  value       = google_compute_address.mc_static_ip.address
}

output "ssh_connection_command" {
  description = "Comando rápido para conectarse por SSH"
  value       = "gcloud compute ssh ${google_compute_instance.mc_instance.name} --project ${var.project_id} --zone ${var.zone}"
}