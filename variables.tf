variable "zone" {
  default = "us-central1-b"
}

variable "instance_start" {
  default = false
}

variable "instance_stop" {
  default = true
}

variable "schedule_start" {
  default = "0 9 * * *"
}

variable "schedule_stop" {
  default = "0 3 * * *"
}

