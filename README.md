# Prueba Técnica - ALBO

## Objetivo
Demostrar el conocimiento y habilidades para la creación de un flujo de automatización y despliegue; así como la optimización y generación de una infraestructura buscando las mejores practicas.

## Herramientas

| Herramienta | Descripción y Uso | Versión |
| --- | --- | --- |
| Terraform | Administración de infraestructura como código | ~> 5.11.0 |
| Amazon EKS | Plataforma para cluster de kubernetes en nube | eks.12 |
| Kubernetes | Administrador para cargas de trabajo y servicios | 1.23 |
| Github | Repositorio de proyectos con control de versiones | - |
| Github Action | Orquestador de automatización y despleigue | - |
| SonarCloud | Analizador de código limpio | - |
| Infracost | Visualizador de costos de infraestructura para la toma de desiciones | - |

## Infraestructura como Código - IaaS
Con la finalidad de tener opciones multicloud ocupamos Terraform como herramienta para la infraestructura como código en nuestro proyecto.

### Terraform
Iniciamos declarando nuestros proveedores en este caso AWS y utilizaremos un bucket de Amazon S3 para guardar el archivo de estado de la infraestructura dandonos libertad de colaborar manteniendo la versión de los recursos - Archivo [terraform.tf](https://github.com/danielramosdlr/prueba-albo/blob/main/terraform.tf)

### Variables y Outputs
Dentro del archivo variables ingresaremos los datos no sensibles del proyecto que nos ayuden a paremetrizar nuestros recursos, haciendo mas facil su utilización en diferentes proyectos - [variables.tf](https://github.com/danielramosdlr/prueba-albo/blob/main/variables.tf).
En nuestro archivo [outputs.tf](https://github.com/danielramosdlr/prueba-albo/blob/main/outputs.tf) podemos encontrar los datos que nos seran de utilidad en la operación de nuestra infraestructura despues de que esta sea desplegada.

### Modulo de Red
Con la finalidad de optimizar el código y mejorar las practicas de seguridad reduciendo tiempo y esfuerzo utilizamos el modulo de terraform para la creacion de una VPC de Amazon siguiendo una arquitectura de dos capas (pública y privada), habilitando la resolución de DNS y comunicación desde internet a nuestra capa pública y la comunicación de salida para mantenimiento desde nuestra capa privada por medio de un NAT Gateway - Archivo [network.tf](https://github.com/danielramosdlr/prueba-albo/blob/main/network.tf)

### Modulo cluster EKS
Para la creación del cluster de kubernetes nos apoyamos con el modulo de terraform para EKS el cual nos ayuda a optimizar tiempo y seguir las buenas practicas de seguridad generando los recursos necesarios de encripción y operación del servicio. Dentro del archivo [cluster-eks.tf](https://github.com/danielramosdlr/prueba-albo/blob/main/cluster-eks.tf) encontramos nuestro modulo definiendo el uso de la capa privada de nuestra red, habilitando la operación del cluster de eks, generando dos grupos de nodos (master y nodos), agregamos la adminsitración de usuarios por medio de identidades de Amazon y los plugin necesarios para la comunicación entre los nodos y los usuarios.

## Flujo de automatización y despliegue
Nos apoyamos de las herramientas y acciones de Github Action para orquestar la automatización y despliegue de la infraestructura como código, agregando las actividades de Escaneo de vulnerabilidades con ayuda de SonarCloud y una vista de los costos aproximados que tendra nuestra infraestructura mensualmente antes de realizar el despliegue de la misma. Archivo [infrastructure.yml](https://github.com/danielramosdlr/prueba-albo/blob/main/.github/workflows/infrastructure.yml).

## Apoyo y vreferencias
- **Modulo Terraform VPC de Amazon** - Versión 5.1.1 - https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
- **Modulo Terrafomr EKS de Amazon** - versión 19.16.0 - https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
- 