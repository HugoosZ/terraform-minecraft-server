# ⛏️ Minecraft Server on Google Cloud with Terraform

Este proyecto automatiza el despliegue de un servidor de Minecraft de alto rendimiento (PaperMC) sobre Google Cloud Platform (GCP) utilizando infraestructura como código con Terraform y contenedores con Docker.

## 🚀 Requisitos previos

- Cuenta de Google Cloud con un proyecto activo.
- Google Cloud SDK (`gcloud`) instalado y configurado.
- Terraform instalado.

## 🛠️ Paso 1: Autenticación en Google Cloud

Antes de ejecutar Terraform, debes identificarte en tu cuenta de Google y configurar el proyecto:

```bash
# Iniciar sesión en Google Cloud
gcloud auth application-default login

# Configurar el ID de tu proyecto
gcloud config set project project-3467abaf-14aa-4dd9-ac1
```

## 🏗️ Paso 2: Despliegue con Terraform

Inicializar el proyecto. Descarga los proveedores necesarios de GCP:

```bash
terraform init
```

Planificar cambios. Previsualiza lo que Terraform creará:

```bash
terraform plan
```

Aplicar infraestructura. Crea la red, IP estática, firewall y la máquina virtual:

```bash
terraform apply
```

Escribe `yes` cuando se te solicite la confirmación.

## 🔍 Paso 3: Monitoreo del despliegue

Una vez que Terraform termina, la VM se enciende y comienza a ejecutar el startup script. Sigue estos pasos para verificar que todo esté funcionando:

### 1. Conexión SSH a la VM

Conéctate de forma segura a través de la consola de Google:

```bash
gcloud compute ssh mc-server-production \
    --project project-3467abaf-14aa-4dd9-ac1 \
    --zone southamerica-west1-a
```

### 2. Verificar la instalación de Docker y dependencias

El script de inicio instala Docker y descarga la imagen de Minecraft. Puedes ver el progreso en tiempo real aquí:

```bash
sudo journalctl -u google-startup-scripts.service -f
```

Espera a ver el mensaje: `Finished Google Compute Engine Startup Scripts`.

### 3. Ver logs del servidor de Minecraft

Una vez que Docker está listo, el servidor de Minecraft comenzará a generar el mundo:

```bash
sudo docker logs -f mc-server
```

Cuando veas `Done (XX.XXs)! For help, type "help"`, el servidor ya acepta conexiones.

## ⚙️ Configuración del servidor

El servidor está estandarizado mediante variables en Terraform para facilitar cambios rápidos:

| Variable | Descripción | Valor actual |
| --- | --- | --- |
| `mc_memory` | RAM asignada a Java | `11G` |
| `mc_view_distance` | Distancia de visión (chunks) | `16` |
| `mc_difficulty` | Dificultad del juego | `hard` |
| `mc_online_mode` | Soporte para cuentas no premium | `FALSE` |

> [!IMPORTANT]
> Modo No-Premium: al estar en `ONLINE_MODE=FALSE`, se recomienda encarecidamente instalar un plugin de autenticación, como AuthMe, para proteger las cuentas de los jugadores.

## 🛠️ Comandos útiles

Entrar a la consola de comandos de Minecraft:

```bash
sudo docker exec -i mc-server rcon-cli
```

Reiniciar el servidor:

```bash
sudo docker restart mc-server
```

Destruir toda la infraestructura:

```bash
terraform destroy
```


