#!/bin/bash

# Variables
VM_NAME="MiVM"
RESOURCE_GROUP="MiGrupo"
LOCATION="East US"


# Abrir puerto 80 en NSG
az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name MiVMNSG \
  --name Allow-HTTP \
  --priority 1000 \
  --protocol Tcp \
  --direction Inbound \
  --source-address-prefixes '*' \
  --source-port-ranges '*' \
  --destination-port-ranges 80 \
  --access Allow

az vm run-command invoke \
  --command-id RunShellScript \
  --name $VM_NAME \
  --resource-group $RESOURCE_GROUP \
  --scripts "sudo apt update && sudo apt install -y nginx"

az vm run-command invoke \
  --command-id RunShellScript \
  --name $VM_NAME \
  --resource-group $RESOURCE_GROUP \
  --scripts "echo '<html><body><h1>Mi MV Azure</h1><p>Desplegado vía Azure CLI</p></body></html>' | sudo tee /var/www/html/index.html"


az vm run-command invoke \
  --command-id RunShellScript \
  --name $VM_NAME \
  --resource-group $RESOURCE_GROUP \
  --scripts "sudo systemctl enable --now nginx"

