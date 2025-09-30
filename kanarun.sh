#!/bin/bash

set -e

if ! getent group uinput >/dev/null; then
  echo "Creating uinput group..."
  sudo groupadd uinput
else
  echo "uinput group already exists."
fi

echo "Adding $USER to uinput group..."
sudo usermod -aG uinput "$USER"

echo "Changing ownership of /dev/uinput..."
sudo chown root:uinput /dev/uinput

echo "Setting permissions on /dev/uinput..."
sudo chmod 660 /dev/uinput

echo "Reloading udev rules..."
sudo udevadm trigger

echo "Switching to shell with new group permissions..."
exec newgrp uinput <<'END_OF_NEWGRP'

echo "Starting Kanata..."
kanata -c /home/abubakr/.config/kanata/config.kbd
END_OF_NEWGRP
