provider "google" {
  version = "~> 2.15"
  project = var.project
  region  = var.region
}

module "app" {
  # Относительный путь к расположению модуля для установки и настройки VM с приложением
  source          = "../modules/app"
  project         = var.project
  public_key_path = var.public_key_path
  app_disk_image  = var.app_disk_image
}

module "db" {
  source          = "../modules/db"
  project         = var.project
  public_key_path = var.public_key_path
  db_disk_image   = var.db_disk_image
}

module "vpc" {
  source          = "../modules/vpc"
  project         = var.project
  public_key_path = var.public_key_path
  source_ranges   = ["94.25.168.212/32"]
}
