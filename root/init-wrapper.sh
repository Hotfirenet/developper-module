#!/bin/bash
set -e

# Lancer le script d'init d'origine en arrière-plan
/root/init.sh &

# Attendre que Jeedom soit accessible
echo "Attente du démarrage de Jeedom..."
until curl -fsS --max-time 2 http://localhost:80 > /dev/null; do
  sleep 2
done
echo "Jeedom est démarré."

# Exécuter les scripts d'init
if [ -d "/init-scripts" ]; then
  for script in /init-scripts/*.sh; do
    if [ -x "$script" ]; then
      echo "Lancement de $script"
      "$script"
    fi
  done
fi

# Attendre la fin du process principal
wait


#exec "$@"
