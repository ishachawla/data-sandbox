.PHONY: help setup infra-init infra-plan infra-apply infra-destroy ingest dbt-deps dbt-run dbt-test dbt-build notebook clean

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

setup: ## Install Python dependencies
	pip install -e ".[dev]"

infra-init: ## Initialize Terraform
	cd terraform && terraform init

infra-plan: ## Plan Terraform changes
	cd terraform && terraform plan -var-file=dev.tfvars

infra-apply: ## Apply Terraform changes
	cd terraform && terraform apply -var-file=dev.tfvars

infra-destroy: ## Destroy Terraform infrastructure
	cd terraform && terraform destroy -var-file=dev.tfvars

ingest: ## Run the ingestion pipeline
	python -m ingestion_pipeline

dbt-deps: ## Install dbt dependencies
	cd dbt && dbt deps

dbt-run: ## Run dbt models
	cd dbt && dbt run

dbt-test: ## Run dbt tests
	cd dbt && dbt test

dbt-build: ## Run dbt build (run + test)
	cd dbt && dbt build

notebook: ## Launch Jupyter notebook
	jupyter notebook --notebook-dir=data_science

clean: ## Remove build artifacts
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name .pytest_cache -exec rm -rf {} + 2>/dev/null || true
	find . -name "*.pyc" -delete 2>/dev/null || true
	find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
