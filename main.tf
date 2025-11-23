resource "random_id" "name" {
  byte_length = 5
  prefix      = "redis-"
}

resource "random_password" "pwd" {
  length = 16
}

resource "kubernetes_secret_v1" "pwd" {
  metadata {
    name        = random_id.name.id
    namespace   = var.namespace
    labels      = var.additionalLabels
    annotations = var.additionalAnnotations
  }
  type = "Opaque"
  data = {
    password = random_password.pwd.result
  }
}

locals {
  username = "redis"
}

output "username" {
  value = local.username
}

output "password" {
  value     = random_password.pwd.result
  sensitive = true
}

locals {
  redisImage = "quay.io/opstree/redis:latest"

  storageClassMixin = var.persistentDiskStorageClass != null ? {
    storageClassName = var.persistentDiskStorageClass,
  } : {}
}

resource "kubernetes_manifest" "main" {
  manifest = {
    apiVersion = "redis.redis.opstreelabs.in/v1beta2"
    kind       = var.clusterMode ? "RedisCluster" : "Redis"
    metadata = {
      name      = random_id.name.id
      namespace = var.namespace
      labels    = var.additionalLabels
      annotations = merge({
        "redisclusters.redis.redis.opstreelabs.in/role-anti-affinity" = "true"
      }, var.additionalAnnotations != null ? var.additionalAnnotations : {})
    }
    spec = merge({
      kubernetesConfig = {
        image           = local.redisImage
        imagePullPolicy = "IfNotPresent"
        redisSecret = {
          name = kubernetes_secret_v1.pwd.metadata[0].name
          key  = "password"
        }
        resources = merge({
          }, var.resourceRequests != null ? {
          requests = var.resourceRequests
          } : {}, var.resourceLimits != null ? {
          limits = var.resourceLimits
        } : {})
      }
      storage = merge({
        volumeClaimTemplate = {
          spec = merge({
            accessModes = ["ReadWriteOnce"]
            resources = {
              requests = {
                storage = var.persistentDiskSize
              }
            }
          }, local.storageClassMixin)
        }
        }, (var.clusterMode ? {
          nodeConfVolume = true
          nodeConfVolumeClaimTemplate = {
            spec = merge({
              accessModes = ["ReadWriteOnce"]
              resources = {
                requests = {
                  storage = "1GB"
                }
              }
            }, local.storageClassMixin)
          }
      } : null))
      redisExporter = {
        enabled = false
      }
      podSecurityContext = {
        runAsUser = 1000
        fsGroup   = 1000
      }
      }, var.clusterMode ? {
      clusterSize = var.clusterSize,
    } : {})
  }
}
