# Techlog

<img src="https://img.shields.io/badge/Kubernetes-326CE5?style=flat-square&logo=kubernetes&logoColor=white"/> <img src="https://img.shields.io/badge/Helm-0F1689?style=flat-square&logo=helm&logoColor=white"> <img src="https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white"/> <img src="https://img.shields.io/badge/CILIUM-F8C517?style=flat-square&logo=cilium&logoColor=black"/> <img src="https://img.shields.io/badge/Vault-FFEC6E?style=flat-square&logo=vault&logoColor=black"> <img src="https://img.shields.io/badge/Keycloak-4D4D4D?style=flat-square&logo=keycloak&logoColor=white"> <img src="https://img.shields.io/badge/Harbor-60B932?style=flat-square&logo=harbor&logoColor=white"> <img src="https://img.shields.io/badge/Kafka-231F20?style=flat-square&logo=apachekafka&logoColor=white"> <img src="https://img.shields.io/badge/Ceph-EF5C55?style=flat-square&logo=ceph&logoColor=white"> <img src="https://img.shields.io/badge/Kubeadm-326CE5?style=flat-square&logo=kubernetes&logoColor=white"/> <img src="https://img.shields.io/badge/Ubuntu-E95420?style=flat-square&logo=ubuntu&logoColor=black"> <img src="https://img.shields.io/badge/ArgoCD-EF7B4D?style=flat-square&logo=argo&logoColor=white"/> <img src="https://img.shields.io/badge/Jenkins-D24939?style=flat-square&logo=jenkins&logoColor=white"/> <img src="https://img.shields.io/badge/Kaniko-FFA600?style=flat-square&logo=kaniko&logoColor=white"/> </br>
<img src="https://img.shields.io/badge/Alloy-F46800?style=flat-square&logo=grafana&logoColor=white"> <img src="https://img.shields.io/badge/OpenTelemetry-000000?style=flat-square&logo=opentelemetry&logoColor=white"> <img src="https://img.shields.io/badge/Loki-F46800?style=flat-square&logo=grafana&logoColor=white"> <img src="https://img.shields.io/badge/GRAFANA-F46800?style=flat-square&logo=grafana&logoColor=white"> <img src="https://img.shields.io/badge/Tempo-F46800?style=flat-square&logo=grafana&logoColor=white"> <img src="https://img.shields.io/badge/Mimir-F46800?style=flat-square&logo=grafana&logoColor=white"> <img src="https://img.shields.io/badge/NginX-009639?style=flat-square&logo=nginx&logoColor=white"> <img src="https://img.shields.io/badge/MinIO-C72E49?style=flat-square&logo=minio&logoColor=white"> <img src="https://img.shields.io/badge/Velero-5D87BF?style=flat-square&logo=v&logoColor=white"> <img src="https://img.shields.io/badge/PostgreSQL-4169E1?style=flat-square&logo=postgresql&logoColor=white"> <img src="https://img.shields.io/badge/S3-569A31?style=flat-square&logo=amazon s3&logoColor=white"> <img src="https://img.shields.io/badge/Redis-DC382D?style=flat-square&logo=redis&logoColor=white">

### **Repository for my home-lab kubernetes cluster**

| Title         | Content                                 |
|--------------|--------------------------------------|
| [Features](#Features) | Main features of Techlog                    |
| [Demo](#Demo) | URL of Techlog              |

## Features

* Gitops with ArgoCD and Vault secret management
* K8s and Applicaiton Observability with LGTM stack and Otel
* Backup with Velero, MinIO, S3
* Server for [home-idp](https://github.com/choigonyok/home-idp) and [techlog](https://github.com/choigonyok/techlog)
* Bare-metal 3 worker nodes kubernetes cluster with Kubeadm and Ubuntu

## Demo

[https://o11y.choigonyok.com](https://o11y.choigonyok.com) (Observability) <br/>
[https://cd.choigonyok.com](https://cd.choigonyok.com) (ArgoCD) <br/>
[https://vault.choigonyok.com](https://vault.choigonyok.com) (Vault) <br/>
[https://kafka.choigonyok.com](https://kafka.choigonyok.com) (Kafka) <br/>
[https://registry.choigonyok.com](https://registry.choigonyok.com) (Harbor) <br/>
[https://s3.choigonyok.com](https://s3.choigonyok.com) (MinIO) <br/>
[https://postgres.choigonyok.com](https://postgres.choigonyok.com) (Zalando PostgreSQL Operator) <br/>
[https://network.choigonyok.com](https://network.choigonyok.com) (Cilium) <br/>
[https://storage.choigonyok.com](https://storage.choigonyok.com) (Ceph) <br/>
[https://www.choigonyok.com](https://www.choigonyok.com) (techlog) <br/>
[https://idp.choigonyok.com](https://idp.choigonyok.com) (home-idp)
