provider "aws" {
  region = var.region

  default_tags {
    tags = {
      "Source"      = "Terrform"
      "Environment" = "Sandbox"
    }
  }
}