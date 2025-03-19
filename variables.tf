variable "user_password" {
  description = "Common password for all users"
  type        = string
  sensitive   = true
}

variable "user_emails" {
  description = "Map of user emails"
  type        = map(string)
  default = {
    "jayesh_soni"              = "jayyesh26@gmail.com"
    "anuj_joshi"               = "anujjoshi89@gmail.com"
    "samir_wankhede"           = "samirsw04@gmail.com"
    "shreenath_bandivadekar"   = "shreenath8.b@gmail.com"
  }
}
