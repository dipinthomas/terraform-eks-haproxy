data "kustomization_build" "haproxy" {
  path = "manifest/kustomize_haproxy"
}

resource "kustomization_resource" "haproxy" {
  for_each = data.kustomization_build.haproxy.ids
  manifest = data.kustomization_build.haproxy.manifests[each.value]

  depends_on = [
    kubernetes_deployment.nginx
  ]
}
