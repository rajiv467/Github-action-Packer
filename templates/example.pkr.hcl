source "amazon-ebs" "autogenerated_1" {
  access_key    = "AKIA4IKFXY6NO37CZBPK"
  ami_name      = "first-ami"
  instance_type = "t2.micro"
  region        = "us-east-1"
  secret_key    = "u5kOnfOyPEyt0a0XexZ/fMBFXUymUQX6RwA/ZX9T"
  source_ami    = "ami-0cff7528ff583bf9a"
  ssh_username  = "ec2-user"
}

build {
  sources = ["source.amazon-ebs.autogenerated_1"]

}