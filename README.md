# Terraform Module : Redis Operator

This repo contains a TF module for use with the Humanitec Platform Operator to provision Redis instances using the [OT-CONTAINER-KIT/redis-operator](https://github.com/OT-CONTAINER-KIT/redis-operator).

## Resource type

NOTE: the resource type below is suitable for Redis Cluster and Redis Standalone with a single discovery hostname in front. It cannot expose the individual node addresses.

```tf
resource "platform-orchestrator_resource_type" "redis" {
    id = "redis"
  output_schema = jsonencode({
    type       = "object"
    required = [
        "hostname",
        "port",
        "username",
        "password",
        "database",
    ]
    properties = {
        hostname = {
            type = "string"
            description = "The hostname that the Redis service can be accessed on."
        }
        port = {
            type = "number"
            description = "The port to access Redis. Usually 6379."
        }
        username = {
            type = "string"
            description = "The Redis username."
        }
        password = {
            type = "string"
            description = "The Redis password."
        }
        database = {
            type = "number"
            description = "The Redis database number. Usually 0."
        }
    }
  })
  is_developer_accessible = true
}
```

## Module input arguments

The following module inputs are supported:

- `namespace: string`: which Kubernetes namespace to create the Redis in.
- `cluster: boolean` (default `false`): whether to use standalone or cluster mode.
- `clusterSize` (default 1): when cluster mode is enabled, the size of the cluster.
- `resources` (default {}): resource requirements includes limits and requests per Redis node.
- `persistenceSize` (default 1GB): persistent disk size.
- `persistenceStorageClass` (default unspecified): the storage class to use for persistent volumes.
