locals {
  annotations = merge(
  {
    "prometheus.io/scrape" = "true"
    "prometheus.io/path" = "/metrics"
    "prometheus.io/port" = tostring(var.port)
    "linkerd.io/inject" = "enabled"
    "vault.hashicorp.com/agent-inject" = tostring(var.inject_vault)
    "vault.hashicorp.com/ca-cert" = "/run/secrets/kubernetes.io/serviceaccount/ca.crt"
    "vault.hashicorp.com/role" = var.vault_role
    "vault.hashicorp.com/log-level" = "debug"
    "vault.hashicorp.com/agent-pre-populate-only" = "true"
    "vault.hashicorp.com/agent-requests-cpu" = "25m"
    "vault.hashicorp.com/agent-init-first" = "true"
  },
  var.annotations
  )
  main_container = {
    name = var.name
    resources = var.resources
    liveness_probe = {
      http_get = {
        port = var.port
        path = "/health"
      }
      initial_delay_seconds = 3
      period_seconds = 3
    }
    image = var.image_tag
    image_pull_policy = "Always"
    command = var.commands
    args = var.args
  }
  sql_container = {
    name = "cloud-sql-proxy"
    image = "gcr.io/cloudsql-docker/gce-proxy:latest"
    security_context = {
      run_as_non_root = true
    }
    volume_mounts = {
      mount_path = "/secrets/"
      read_only = true
      name = "cardbox-db-secret"
    }
  }
}

resource "kubernetes_deployment" "deployments" {
  metadata {
    name = "${var.name}-deployment"
    namespace = "cardbox"
  }
  spec {
    selector {
      match_labels = var.match_labels
    }
    replicas = var.replicas
    template {
      metadata {
        namespace = "cardbox"
        labels = var.match_labels
        annotations = local.annotations
      }
      spec {
        service_account_name = var.service_account_name
        dynamic "container" {
          for_each = var.needs_cloud_sql ? [local.main_container] : [local.main_container]
          content {
            name = container.value.name
            dynamic "resources" {
              for_each = container.value.resources
              content {
                
              }
            }
          }
        }
      }
    }
  }
}