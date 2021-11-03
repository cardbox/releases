variable "image_tag" {
  description = "Image tag to use in deployment"
  type = string
}

variable "name" {
  type = string
  description = "Deployment name"
}

variable "match_labels" {
  description = "Match labels deployment"
  type = map(string)
}

variable "replicas" {
  type = number
  description = "Replicas amount"
  default = 3
}

variable "port" {
  description = "Deployment open port"
  type = number
}

variable "vault_role" {
  description = "Vault role"
  type = string
  default = null
}

variable "inject_vault" {
  description = "Inject vault agent"
  type = bool
}

variable "annotations" {
  description = "Annotations to add"
  type = map(string)
  default = null
}

variable "needs_cloud_sql" {
  description = "Include container for cloud sql proxy"
  type = bool
  default = false
}

variable "service_account_name" {
  description = "Service account name for pod"
  type = string
  default = null
}

variable "resources" {
  type = map(string)
  description = "Container resources"
  default = null
}

variable "commands" {
  type = list(string)
  description = "Container commands"
  default = null
}

variable "args" {
  type = list(string)
  description = "Container args"
  default = null
}

variable "env" {
  type = map(string)
  description = "Container envs"
  default = null
}