mock_provider "kubernetes" {

}

run "plan" {
  command = plan
  variables {
    namespace   = "default"
    clusterMode = true
    clusterSize = 3
    resources = {
      requests = {
        cpu    = "1"
        memory = "2GB"
      }
      limits = {
        cpu    = "4"
        memory = "8GB"
      }
    }
    persistentDiskStorageClass = "standard"
    persistentDiskStorageSize  = "10GB"
    additionalLabels = {
      app = "some-value"
    }
    additionalAnnotations = {
      "vegetable.io/type" = "cabbage"
    }

  }
}
