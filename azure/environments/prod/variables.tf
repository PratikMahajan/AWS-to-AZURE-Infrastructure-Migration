variable "env" {}
variable "domain_name" {}

variable "location" {}
variable "vnet_addr" {}
variable "subnet1_addr" {}
variable "subnet2_addr" {}
variable "subnet3_addr" {}
variable "lb_ip_dns_name" {}

variable "storage_account_name" {}

variable "maria_db_server_scale_capacity" {}
variable "maria_db_storage_mb" {}
variable "mariadb_admin_login_password" {}
variable "mariadb_admin_login_username" {}
variable "mariadb_name" {}
variable "mariadb_ssl_enforcement" {}

variable "topic" {}

variable "cosmos_acct_name" {}
variable "cosmos_tbl_name" {}
variable "failover_loc" {}

variable "function_bolb_name" {}
variable "function_name" {}


variable "hostname" {}
variable "ssh_key" {}
variable "image_name" {}
variable "vm_increase_threshold" {}
variable "vm_decrease_threshold" {}

variable "domain_name_tld" {}

//variable "cert_issuer_name" {}
variable "cert_password" {}
variable "cert_path" {}
//variable "sp_object_id" {}
//variable "tenet_id" {}