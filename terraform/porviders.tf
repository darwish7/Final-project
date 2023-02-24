provider "aws" {
  shared_credentials_files = ["/home/darwish/.aws/credentials"]
  shared_config_files      = ["/home/darwish/.aws/conf"]
  region = "us-east-1"
  profile = "final-task"
}
  