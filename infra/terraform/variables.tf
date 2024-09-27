variable "main_vpc" {
  description = "ID da VPC onde os recursos serão alocados"
  type        = string
  default     = "vpc-08ce9dcf2e20ae48b"
}

variable "public_subnets" {
  description = "Lista de IDs de sub-redes na VPC"
  type        = list(string)
  default     = [
    "subnet-070c4b088ce79305e", 
    "subnet-0459fe07a3e9ecc5b",
	"subnet-025dd2b4cd71ffeb3"
  ]  
}