variable "main_vpc" {
  description = "ID da VPC onde os recursos serão alocados"
  type        = string
  default     = "vpc-08ce9dcf2e20ae48b"
}

variable "cluster_name" {
  description = "nome do clister eks"
  type        = string
  default     = "authcloud-cluster"
}

