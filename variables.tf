variable "zone" {
  description = "zone with the instance"
  default = "us-central1-b"
}

variable "instance_start" {
  description = "flag to start instance"
  default = true
}

variable "instance_stop" {
  description = "flag to stop instance"
  default = true
}

variable "schedule_start" {
  description = "schedule to start"
  default = "0 9 * * *"
}

variable "schedule_stop" {
  description = "schedule to stop"
  default = "0 3 * * *"
}

