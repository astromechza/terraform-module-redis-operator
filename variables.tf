variable "namespace" {
  type        = string
  description = "The namespace to create the Redis cluster in."
}

variable "clusterMode" {
  type        = bool
  default     = false
  description = "Whether cluster mode is disabled (the default) or enabled. When cluster mode is enabled, only standalone mode is used."
}

variable "clusterSize" {
  type        = number
  default     = 1
  description = "The number of cluster nodes."

  validation {
    condition     = var.clusterSize >= 1
    error_message = "Cluster size must be >= 1."
  }
}

variable "resources" {
  type = object({
    requests = object({
      cpu    = string
      memory = string
    })
    limits = object({
      cpu    = string
      memory = string
    })
  })
  default     = null
  description = "The resource limits and requests for each cluster node."
}

variable "persistentDiskSize" {
  type        = string
  default     = "1GB"
  description = "The persistent disk size."
}

variable "persistentDiskStorageClass" {
  type        = string
  default     = null
  description = "The storage class to use for persistent disks."
}

variable "additionalLabels" {
  type        = map(any)
  default     = null
  description = "Additional labels to add to the created resources."
}

variable "additionalAnnotations" {
  type        = map(any)
  default     = null
  description = "Additional annotations to add to the created resources."
}
