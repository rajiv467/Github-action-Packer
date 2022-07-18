resource "aws_instance" "app-server" {
    ami = data.aws_ami.window-server-sql-2017.id
    instance_type = "c5n.xlarge"
    subnet_id = aws_subnet.public-subnet.id
    key_name = aws_key_pair.key_pair.key_name
    security_groups = [aws_security_group.private-sg.id]
    //vpc_security_group_ids = [aws_security_group.private-sg.id]
    
    tags = {
      "Name" = "App-Server"
    }
}

