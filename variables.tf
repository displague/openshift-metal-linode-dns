variable "linode_domain" {
  description = "Name of the linode domain. This will be the cluster base domain. (example: example.com)"
}
variable "cluster_name" {
  description = "Name of the OpenShift cluster. This will be the sub-domain for openshift domain records. (example: ocp4)"
}
variable "linode_token" {
  description = "Linode Token with Domain writing permission"
  sensitive   = true
}
variable "metal_token" {
  description = "Equinix Metal API token with IP reservation creation permission"
  sensitive   = true
}
variable "metal_metro" {
  description = "Equinix Metal Metro to create the IP addresses in"
}
variable "metal_project_id" {
  description = "Equinix Metal Project to create the IP addresses in"
}
