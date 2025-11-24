output "hostname" {
  value = random_id.name.hex
}

output "port" {
  value = 6379
}

output "username" {
  value = ""
}

output "password" {
  value     = random_password.pwd.result
  sensitive = true
}

output "database" {
  value = 0
}
