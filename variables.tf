variable "aws_region" {
  description = "Región AWS"
  type        = string
  default     = "us-east-2" 
}

variable "ssh_allowed_cidr" {
  type        = string
}

variable "public_key_path" {
  type        = string
}

variable "instance_type" {
  type        = string
}

variable "tags" {
  type        = map(string)
}
variable "ddb_table_name" {
  description = "Nombre de la tabla DynamoDB"
  type        = string
  default     = "app-items"
}

variable "ddb_pk_name" {
  type        = string
  default     = "pk"
}

variable "env" {
  description = "environment"
  type        = string
}

variable "billing_mode"{
  type =string
}