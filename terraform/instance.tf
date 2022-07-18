
resource "aws_instance" "bastion-vm" {
    #ami = "ami-0a4722105d5286695"
    ami = data.aws_ami.windows-2019.id
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public-subnet.id
    key_name = aws_key_pair.key_pair.key_name
    security_groups = [aws_security_group.bastion-sg.id]
   // vpc_security_group_ids = [aws_security_group.bastion-sg.id]

    /*
      user_data = data.template_file.windows-userdata.rendered 
  associate_public_ip_address = var.windows_associate_public_ip_address
  
  # root disk
  root_block_device {
    volume_size           = var.windows_root_volume_size
    volume_type           = var.windows_root_volume_type
    delete_on_termination = true
    encrypted             = true
  }
  # extra disk
  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = var.windows_data_volume_size
    volume_type           = var.windows_data_volume_type
    encrypted             = true
    delete_on_termination = true
  }
  */

    tags = {
      "Name" = "Bastion-Host"
    }
  
}


resource "null_resource" "copy_key" {
  depends_on = [aws_instance.bastion-vm]
   provisioner "file" {
    source      = "windows-key-pair.pem"
    destination = "/home/ec2-user/windows-key-pair.pem"
    connection {
    type     = "winrm"
    user     = "Administrator"
    private_key = file("${aws_key_pair.key_pair.key_name}.pem")
    host     = "${aws_instance.bastion-vm.public_ip}"
  }
  }
  
}