variable "project_id" {
  description = "Project ID in google cloud"
  type        = string
}

variable "region" {
  default = "europe-central2" # Warszawa
}

variable "zone" {
  default = "europe-central2-a"
}