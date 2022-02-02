data "kustomization" "haproxy" {
  path = "manifest/kustomize_haproxy"
}

resource "kustomization_resource" "haproxy" {
  for_each = data.kustomization.haproxy.ids
  manifest = data.kustomization.haproxy.manifests[each.value]

  depends_on = [
    kubernetes_deployment.nginx
  ]
}