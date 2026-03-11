ui = true

disable_mlock = true

listener "tcp" {
  address = "0.0.0.0:8200"
  cluster_address = "0.0.0.0:8201"

  tls_disable = 1

  telemetry {
    unauthenticated_metrics_access = true
  }
}

storage "raft" {

  path = "/vault/data"

  node_id = "vault-node"

  retry_join {
    leader_api_addr = "http://vault:8200"
  }
}

api_addr = "https://vault.remotecodehub.com"
cluster_addr = "http://vault:8201"

log_level = "info"

service_registration "kubernetes" {}