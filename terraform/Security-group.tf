#public-bastion SG

resource "aws_security_group" "bastion-sg" {
    vpc_id = aws_vpc.myvpc.id
    name = "Bastion-sg-allow-3389"
    ingress {
        from_port = 3389
        to_port = 3389
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      "Name" = "Bastion-Public-sg"
    }
}


#Private Sg
resource "aws_security_group" "private-sg" {
    vpc_id = aws_vpc.myvpc.id
    name = "Private-sg"
    description = "Allow vpc-traffic"
    ingress {
        from_port = 3389
        to_port = 3389
        protocol = "tcp"
        #cidr_blocks = [aws_vpc.myvpc.cidr_block]
        security_groups = [aws_security_group.bastion-sg.id]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      "Name" = "Private-Sg"
    }
  
}

/*
resource "aws_security_group_rule" "Priavte-sg-rule" {  
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.myvpc.cidr_block]
  security_group_id = "aws_security_group.private-sg.id"
  source_security_group_id = "aws_security_group.bastion-sg"
}


*/
