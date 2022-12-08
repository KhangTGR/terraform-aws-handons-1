output "public_dns_name" {
  description = "Public DNS names of the load balancer for this project"
  value       = module.elb_http.this_elb_dns_name
}

output "app_public_dns_name" {
  description = "Public DNS names of the load balancer for this app"
  value = "${module.elb_http.this_elb_dns_name}/app.html"
}