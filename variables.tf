variable "service" {
  description = "The name of the service being deployed"
  type        = string
}

variable "location" {
  description = "The location the service is being deployed to"
  type        = string
}

variable "resource_group" {
  description = "The location the service is being deployed to"
  type        = string
}

variable "subnet" {
  description = "The subnet the service is being deployed to"
  type        = string
}

variable "registry" {
  description = "The registry the image will be pulled from"
  type        = object({
    username = string
    password = string
    server   = string
  })
}

variable "container" {
  description = "The details of the container that is being deployed"
  type        = object({
    cpu         = number
    memory      = number
    image       = string
    environment = map(string)
    port        = number
    platform   = string
  })
}
