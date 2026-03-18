output "raw_bucket_name" {
  description = "GCS bucket for raw ingested data"
  value       = google_storage_bucket.raw_data.name
}

output "bq_dataset_id" {
  description = "BigQuery dataset for dbt models"
  value       = google_bigquery_dataset.sandbox.dataset_id
}

output "bq_raw_dataset_id" {
  description = "BigQuery dataset for raw ingested data"
  value       = google_bigquery_dataset.raw.dataset_id
}

output "pipeline_service_account_email" {
  description = "Pipeline service account email"
  value       = google_service_account.pipeline.email
}

output "pipeline_service_account_key" {
  description = "Pipeline service account key (base64-encoded JSON)"
  value       = google_service_account_key.pipeline_key.private_key
  sensitive   = true
}
