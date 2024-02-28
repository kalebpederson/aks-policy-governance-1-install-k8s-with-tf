variable "target_region" {
  type    = string
  default = "centralus"
  description = "Azure region in which resources will be deployed."
}

variable "environment" {
  type    = string
  default = "development"
  description = "The current environment"
}

variable "aks_admin_group_object_ids" {
  type = list(string)
  # allow admin access to the 'aks-cluster-admin' group:
  default = ["953d7fdb-afd1-48ab-8fa6-bbb39a407089"]
}

variable "project_name" {
  type    = string
  default = "kpp-com-tst1"
  description = "A unique name given to the project."
}

variable "subscription_id" {
  type = string
  # p12m subscription
  # default = "0274e675-d89b-4ff7-9b41-b0fb57651874"
  # VS Premium: 115bb65e-1ad5-4f9d-a4ab-93d5b6952245
  # VS Enterprise: 904c6d56-bed5-4d1c-b415-041ad337f986
  default = "115bb65e-1ad5-4f9d-a4ab-93d5b6952245" 
}