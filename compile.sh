#!/bin/bash

# Skrypt automatyzujący czyszczenie i budowanie Archiso z Calamares
# Autor: MaciekOS Builder

# Kolory dla lepszej czytelności logów
ZELONY='\033[0;32m'
CZERWONY='\033[0;31m'
NIEBIESKI='\033[0;34m'
ZOLTY='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${NIEBIESKI}==================================================${NC}"
echo -e "${ZOLTY}             STARTING THE ISO BUILD PROCESS           ${NC}"
echo -e "${NIEBIESKI}==================================================${NC}"

# 1. Sprawdzenie uprawnień roota
if [ "$EUID" -ne 0 ]; then
  echo -e "${CZERWONY}[!] This script must be run with sudo/root privileges!${NC}"
  echo -e "Use: sudo ./compile.sh"
  exit 1
fi

# Ścieżki projektu (ustawione pod Twój projekt)
PROJEKT_DIR="/usr/share/archiso/configs/releng"
REPO_DIR="$PROJEKT_DIR/local_repo"
WORK_DIR="/usr/share/archiso/configs/releng/work"
PAKIE_SRC="/home/Maciek/calamares-3.4.2-2-x86_64.pkg.tar.zst"

echo -e "\n${NIEBIESKI}[1/2] Cleaning up old working directory...${NC}"
if [ -d "$WORK_DIR" ]; then
    rm -rf "$WORK_DIR"
    echo -e "${ZELONY}[+ ] directory $WORK_DIR was successfully deleted.${NC}"
else
    echo -e "${ZOLTY}[~] The working directory was now clean.${NC}"
fi


echo -e "\n${NIEBIESKI}[2/2] Running mkarchiso build...${NC}"
cd "$PROJEKT_DIR" || exit 1

mkarchiso -v -w "$WORK_DIR" -o out/ .

if [ $? -eq 0 ]; then
    echo -e "\n${ZELONY}==================================================${NC}"
    echo -e "${ZELONY} SUCCESS! ISO file successfully created in out/ ${NC}"
    echo -e "${ZELONY}==================================================${NC}"
else
    echo -e "\n${CZERWONY}==================================================${NC}"
    echo -e "${CZERWONY} ERROR: ISO build failed! ${NC}"
    echo -e "${CZERWONY}==================================================${NC}"
    exit 1
fi
