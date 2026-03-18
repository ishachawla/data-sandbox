terraform {
  required_version = ">= 1.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# BigQuery dataset for raw ingested data
resource "google_bigquery_dataset" "raw" {
  dataset_id  = "${var.bq_dataset}_raw"
  location    = var.bq_location
  description = "Raw ingested data landing zone"

  delete_contents_on_destroy = true

  labels = {
    env     = var.environment
    managed = "terraform"
  }
}

# BigQuery dataset for dbt modeled data
resource "google_bigquery_dataset" "sandbox" {
  dataset_id  = var.bq_dataset
  location    = var.bq_location
  description = "Data sandbox dev dataset for dbt modeling"

  delete_contents_on_destroy = true

  labels = {
    env     = var.environment
    managed = "terraform"
  }
}

# Cloud Storage bucket for raw data archival
resource "google_storage_bucket" "raw_data" {
  name                        = "${var.project_id}-raw"
  location                    = var.region
  force_destroy               = true
  uniform_bucket_level_access = true

  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type = "Delete"
    }
  }

  labels = {
    env     = var.environment
    managed = "terraform"
  }
}

# Service account for data pipeline
resource "google_service_account" "pipeline" {
  account_id   = "data-sandbox-pipeline"
  display_name = "Data Sandbox Pipeline"
  description  = "Service account for ingestion pipeline and dbt"
}

# Grant BigQuery Admin to service account
resource "google_project_iam_member" "pipeline_bq_admin" {
  project = var.project_id
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:${google_service_account.pipeline.email}"
}

# Grant Storage Admin to service account
resource "google_project_iam_member" "pipeline_gcs_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.pipeline.email}"
}

# Generate service account key
resource "google_service_account_key" "pipeline_key" {
  service_account_id = google_service_account.pipeline.name
}
