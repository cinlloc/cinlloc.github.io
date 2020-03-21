#!/bin/bash

WORKDIR=/tmp
FILENAME=luniistore-2.0.2.x86_64.rpm

which java &>/dev/null
if [[ $? -ne 0 ]]; then
   echo "Java doit être installé pour exécuter le Luniistore. Merci d'installer Java. "
   exit 1
fi

echo "Téléchargement depuis le site de Lunii"
wget -c https://storage.googleapis.com/storage.lunii.fr/public/deploy/installers/linux/64bits/$FILENAME -O $WORKDIR/$FILENAME

sudo pacman -Qi rpmextract &>/dev/null
if [[ $? -ne 0 ]]; then
   echo "Installation de rpmextract"
   sudo pacman -S rpmextract --noconfirm
fi

echo "Extraction du RPM"
cd /
sudo rpmextract.sh $WORKDIR/$FILENAME

echo "Création du raccourci"
sed "s/Exec=/Exec=gksudo /" /opt/Luniistore/Luniistore.desktop > ~/Bureau/Luniistore.desktop
chmod +x ~/Bureau/Luniistore.desktop

echo "C'est fini ! Vous n'avez plus qu'à double-cliquer sur le raccourci de votre bureau !"
