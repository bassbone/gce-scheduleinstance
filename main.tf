resource "google_pubsub_topic" "start" {
  name = "start-instance-event"
}

resource "google_pubsub_topic" "stop" {
  name = "stop-instance-event"
}

resource "random_string" "bucket_name" {
  length = 16
  upper = false
  special = false
}

resource "google_storage_bucket" "default" {
  name = random_string.bucket_name.result
}

resource "google_storage_bucket_object" "default" {
  name   = "index.zip"
  bucket = google_storage_bucket.default.name
  source = "./index.zip"
}

resource "google_cloudfunctions_function" "start" {
  name        = "startInstancePubSub"
  description = "startInstancePubSub"
  runtime     = "nodejs10"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.default.name
  source_archive_object = google_storage_bucket_object.default.name
  entry_point           = "startInstancePubSub"
  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.start.id
  }
}

resource "google_cloudfunctions_function" "stop" {
  name        = "stopInstancePubSub"
  description = "stopInstancePubSub"
  runtime     = "nodejs10"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.default.name
  source_archive_object = google_storage_bucket_object.default.name
  entry_point           = "stopInstancePubSub"
  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.stop.id
  }
}

resource "google_cloud_scheduler_job" "start" {
  count       = var.instance_start ? 1 : 0
  name        = "startup-dev-instances"
  description = "startup-dev-instances"
  schedule    = var.schedule_start
  time_zone   = "Asia/Tokyo"

  pubsub_target {
    topic_name = google_pubsub_topic.start.id
    data       = base64encode("{\"zone\":\"${var.zone}\", \"label\":\"env=dev\"}")
  }
}

resource "google_cloud_scheduler_job" "stop" {
  count       = var.instance_stop ? 1 : 0
  name        = "shutdown-dev-instances"
  description = "shutdown-dev-instances"
  schedule    = var.schedule_stop
  time_zone   = "Asia/Tokyo"

  pubsub_target {
    topic_name = google_pubsub_topic.stop.id
    data       = base64encode("{\"zone\":\"${var.zone}\", \"label\":\"env=dev\"}")
  }
}

