variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "Environment label (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "bq_dataset" {
  description = "BigQuery dataset name"
  type        = string
  default     = "data_sandbox_dev"
}

variable "bq_location" {
  description = "BigQuery dataset location"
  type        = string
  default     = "US"
}
