mock_provider "kubernetes" {

}

run "plan" {
  command = plan
  variables {
    namespace = "default"
  }
}
