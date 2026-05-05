provider "google" {
  project = var.project_id
  region  = var.region
}

# 1. Red dedicada para el servidor
resource "google_compute_network" "mc_network" {
  name = "network-minecraft"
}

# 2. Firewall: Limpio y específico
resource "google_compute_firewall" "mc_firewall" {
  name    = "allow-minecraft-and-ssh"
  network = google_compute_network.mc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22", "25565"] # SSH y Minecraft
  }

  allow {
    protocol = "udp"
    ports    = ["25565"] # Necesario para Query y estabilidad
  }

  source_ranges = ["0.0.0.0/0"]
}

# 3. IP Estática
resource "google_compute_address" "mc_static_ip" {
  name   = "ip-estatica-minecraft"
  region = var.region
}

# 4. VM con Startup Script dinámico
resource "google_compute_instance" "mc_instance" {
  name         = var.mc_instance_name
  machine_type = var.mc_machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = var.mc_disk_size_gb
    }
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y docker.io
    systemctl start docker
    systemctl enable docker

    mkdir -p /opt/minecraft

    docker run -d \
        -v /opt/minecraft:/data \
        -e TYPE=PAPER \
        -e EULA=TRUE \
        -e ONLINE_MODE=${var.mc_online_mode} \
        -e DIFFICULTY=${var.mc_difficulty} \
        -e MEMORY=${var.mc_memory} \
        -e VERSION=${var.mc_version} \
        -e OVERRIDE_SERVER_PROPERTIES=true \
        -e VIEW_DISTANCE=${var.mc_view_distance} \
        -p 25565:25565 \
        --name mc-server \
        --restart always \
        itzg/minecraft-server
  EOT

  network_interface {
    network = google_compute_network.mc_network.name
    access_config {
      nat_ip = google_compute_address.mc_static_ip.address
    }
  }
}