# Cluster Swarm avec Terraform et Scaleway

## Prérequis
- Docker
- Make
- Un compte Scaleway

## Utilisation

Vous devez copier le fichier d'exemple et y insérer votre token et organization.  
``cp terraform.tfvars.example terraform.tfvars``.  
Une fois cela rélaisé, vous devez ajouter votre clée SSH dans le dossier tmp ``mkdir -p tmp && ln -s ~/.ssh/id_rsa tmp/id_rsa``
Puis vous devez faire un ``make apply``.

Et voilà, votre cluster Docker Swarm est disponible & fonctionnel.

