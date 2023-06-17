data "terraform_remote_state" "level1" {

  backend = "s3"
  config = {

    bucket = "terra-remote-st"
    key    = "level1.tfstate"
    region = "ap-south-1"

  }

}
