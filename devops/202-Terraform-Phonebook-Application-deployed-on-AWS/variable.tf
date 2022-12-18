variable "key_name" {
  key_name = "firstkey"
}

variable "az" {
  type = "list"
  default = ["us-east-1a, us-east-1b"]
}

variable "server-name" {
  default = "Web Server of Phonebook App"
  
}

variable "default_vpc_id" {
  default = "vpc-0bde5a6bb06a5cb93"
}