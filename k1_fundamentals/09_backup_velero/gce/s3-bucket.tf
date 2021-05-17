### S3 bucket for tf-state
resource "google_storage_bucket" "s3-storage" {
  name = "k1-backup-bucket"
  storage_class = "STANDARD"
  location = var.region
}

### create SA binding
# gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member serviceAccount:$GCP_SERVICE_ACCOUNT_ID --role='roles/storage.admin'

### PUBLIC read/write not recommended for production
//resource "google_storage_bucket_access_control" "public_rule" {
//  bucket = google_storage_bucket.s3-storage.name
//  role   = "WRITER"
//  entity = "allUsers"
//}

output "s3" {
  value = {
    name = google_storage_bucket.s3-storage.name
    url = google_storage_bucket.s3-storage.url
  }
}
