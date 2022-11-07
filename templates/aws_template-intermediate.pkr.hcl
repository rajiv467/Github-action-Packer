
variable "AWS_ACCESS_KEY" {
  type    = string
  default = "AKIAR5JIQX64NMKDRQOY"
}

variable "AWS_SECRET_KEY" {
  type    = string
  default = "5p3y6CVtPuzsZrPJqDyuDnMJARHMX20jeNoHgXtz"
}

variable "DESTINATION_REGIONS" {
  type    = string
  default = "us-west-1"
}
/*
variable "GITHUB_TOKEN" {
  type    = string
  default = ""
}
*/
data "amazon-ami" "autogenerated_1" {
  access_key = "${var.AWS_ACCESS_KEY}"
  filters = {
    name                = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["099720109477"]
  region      = "us-west-1"
  secret_key  = "${var.AWS_SECRET_KEY}"
}

source "amazon-ebs" "autogenerated_1" {
  access_key            = "${var.AWS_ACCESS_KEY}"
  ami_name              = "packer-vanilla-t2.micro"
  ami_regions           = ["${var.DESTINATION_REGIONS}"]
  force_delete_snapshot = "true"
  force_deregister      = "true"
  instance_type         = "t2.micro"
  region                = "us-west-1"
  secret_key            = "${var.AWS_SECRET_KEY}"
  source_ami            = "${data.amazon-ami.autogenerated_1.id}"
  ssh_username          = "ubuntu"
  #user_data_file        = "/github/workspace/scripts/install_jenkins.sh"
}

build {
  sources = ["source.amazon-ebs.autogenerated_1"]
/*
  provisioner "shell" {
    inline = ["echo '${var.GITHUB_TOKEN} > ~/token.txt"]
  }

  provisioner "shell" {
    inline = ["sleep 30", "sudo yum update -y", "sudo yum install git make gcc -y", "curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.35.3/install.sh | bash", "source ~/.bashrc", "nvm install 12", "npm install -g npm@latest", "node app/webserver.js"]
  }
*/
}
