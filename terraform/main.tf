provider "kubernetes" {
  config_path = "~/.kube/config"
}

locals {
  api-internal-deploy = {
    image_tag = "eu.gcr.io/fair-terminus-322419/cardbox/backend/api-internal:latest"
    name = "cardbox-api-internal"
    match_labels = {
      app = "cardbox"
      tier = "api-internal"
    }
    replicas = 4
    port = 9110
    vault_role = "cardbox-api-internal-role"
    inject_vault = true
    annotations = {
      "vault.hashicorp.com/agent-inject-secret-db" = "kv/data/cardbox-database"
      "vault.hashicorp.com/agent-inject-template-db" = <<-EOT
      {{ with secret "kv/data/cardbox-database" -}}
        export POSTGRES_USER="{{ .Data.data.POSTGRES_USER }}"
        export POSTGRES_PASSWORD="{{ .Data.data.POSTGRES_PASSWORD }}"
        export POSTGRES_DB="{{ .Data.data.POSTGRES_DB }}"
        export CARDBOX_DATABASE__DATABASE=$${POSTGRES_DB}
        export CARDBOX_DATABASE__PASSWORD=$${POSTGRES_PASSWORD}
        export CARDBOX_DATABASE__USER=$${POSTGRES_USER}
      {{- end }}
      EOT
    }
    needs_cloud_sql = true
    service_account_name = "test"
  }
  deploys = [local.api-internal-deploy]
}

module "k8s_deploy" {
  for_each = { for deploy in local.deploys : deploy.name => deploy }
  image_tag = each.value.image_tag
  name = each.value.name
  match_labels = each.value.match_labels
  inject_vault = each.value.inject_vault
  port = each.value.port
  vault_role = each.value.vault_role
  source = "./modules/k8s-deployments"
}