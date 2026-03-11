path "secret/data/rsv/*" {
  capabilities = ["read", "update"]
}

path "secret/metadata/rsv/*" {
  capabilities = ["list"]
}