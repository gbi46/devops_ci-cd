output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "jenkins_url" {
  value = module.jenkins.url
}

output "argocd_url" {
  value = module.argo_cd.url
}
