variable "project_id" {
  description = "ID del proyecto de Google Cloud (Ej: project-3467abaf-14aa-4dd9-ac1"
  type        = string
  default     = "project-3467abaf-14aa-4dd9-ac1"
}

variable "region" {
  default = "southamerica-west1"
  type    = string
}

variable "zone" {
  default = "southamerica-west1-a"
  type    = string
}

# --- Variables de Minecraft ---
variable "mc_instance_name" {
  default = "mc-server-production"
  type    = string
}

variable "mc_machine_type" {
  default     = "e2-standard-4" # 4 vCPU, 16GB RAM
  description = "Tipo de máquina. Minecraft Paper requiere al menos 4GB libres."
  type        = string
}

variable "mc_disk_size_gb" {
  default = 100
  type    = number
}

variable "mc_memory" {
  default     = "13G"
  description = "Memoria RAM asignada al proceso de Java"
  type        = string
}

variable "mc_online_mode" {
  default     = "FALSE"
  description = "FALSE para permitir usuarios No-Premium (piratas)"
  type        = string
}

variable "mc_version" {
  default = "LATEST"
  type    = string
}

variable "mc_difficulty" {
  default     = "hard"
  description = "Dificultad del mundo: peaceful, easy, normal, hard"
  type        = string
}

variable "mc_view_distance" {
  default     = 18  # Subimos de 12 a 18 aprovechando los 13GB
  description = "Radio de chunks que el servidor envía al jugador"
  type        = number
}