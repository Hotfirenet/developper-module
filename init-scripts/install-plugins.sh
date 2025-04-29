#!/bin/sh
set -e

PLUGINS_DIR="/var/www/html/plugins"

if [ -d /plugins-srv ]; then
  rm -rf $PLUGINS_DIR
  ln -s /plugins-srv $PLUGINS_DIR
  echo "Création du lien symbolique."
  chown -R www-data:www-data $PLUGINS_DIR
  chmod -R 755 $PLUGINS_DIR
  echo "Changement de propriétaire et de permissions."
fi

for plugin_path in "$PLUGINS_DIR"/*; do
  echo "Vérification du plugin : $plugin_path"
  if [ -d "$plugin_path" ] && [ -f "$plugin_path/plugin_info/info.json" ]; then
    plugin_id=$(basename "$plugin_path")
    echo "Installation du plugin : $plugin_id"
    jeecli plugin incd pl   stall "$plugin_id"
  fi
done
