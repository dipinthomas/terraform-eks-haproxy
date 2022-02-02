output "endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value     = aws_eks_cluster.cluster.certificate_authority[0].data
  sensitive = true
}

output "region" {
  value = var.region
}

output "clusterName" {
  value = var.clusterIdentifier
}