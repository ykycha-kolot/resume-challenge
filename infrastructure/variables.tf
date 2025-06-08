variable "region" {
  default = "us-east-1"
  type    = string
}
variable "user_account" {
  default = "tf_user"
  type    = string
}
variable "domain_name" {
  default = "yurii-k.xyz"
  type    = string
}
variable "dynamodb_table_name" {
  default = "user_count"
  type    = string
}
variable "origin_name" {
  default = "resume-bucket-tf_origin"
  type    = string
}
variable "s3_bucket_name" {
  default = "resume-bucket-tf"
  type    = string
}
variable "api_gateway_name" {
  default = "get-user-count-api"
  type    = string
}