terraform {
  required_providers {
    metal = {
      source = "equinix/metal"
    }
    linode = {
      source = "linode/linode"
    }
  }
}
provider "linode" {
  token = var.linode_token
}
provider "metal" {
  auth_token = var.metal_token
}

resource "metal_reserved_ip_block" "ips" {
  project_id = var.metal_project_id
  type       = "public_ipv4"
  metro      = var.metal_metro
  quantity   = 8
}

data "linode_domain" "domain" {
  domain = var.linode_domain
}

resource "linode_domain_record" "lb" {
  domain_id   = data.linode_domain.domain.id
  name        = "api.${var.cluster_name}"
  record_type = "A"
  target      = cidrhost(metal_reserved_ip_block.ips.cidr_notation, 0)
}

resource "linode_domain_record" "lb-int" {
  domain_id   = data.linode_domain.domain.id
  name        = "api-int.${var.cluster_name}"
  record_type = "A"
  target      = cidrhost(metal_reserved_ip_block.ips.cidr_notation, 0)
}

resource "linode_domain_record" "bootstrap" {
  domain_id   = data.linode_domain.domain.id
  name        = "bootstrap.${var.cluster_name}"
  record_type = "A"
  target      = cidrhost(metal_reserved_ip_block.ips.cidr_notation, 4)
}

resource "linode_domain_record" "master" {
  count       = 3
  domain_id   = data.linode_domain.domain.id
  record_type = "A"
  name        = "master${count.index}.${var.cluster_name}"
  target      = cidrhost(metal_reserved_ip_block.ips.cidr_notation, count.index)
}

resource "linode_domain_record" "apps" {
  domain_id   = data.linode_domain.domain.id
  name        = "*.apps.${var.cluster_name}"
  record_type = "A"
  target      = cidrhost(metal_reserved_ip_block.ips.cidr_notation, 0)
}
