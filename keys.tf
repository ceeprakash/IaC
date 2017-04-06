resource "aws_key_pair" "admin_key" {
    key_name = "admin_key"
    public_key = "${file("${var.aws_ssh_admin_key_file}.pub")}"
}

resource "aws_security_group" "base_security_group" {
    name = "base_security_group"
    description = "Base Security Group"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["192.55.79.168/32"]
    }

    /*egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }*/

    tags {
        Name = "base_security_group"
    }
}

resource "aws_instance" "dev" {
    ami = "${var.ami}"
    instance_type = "${var.aws_instance_type}"
    key_name = "${aws_key_pair.admin_key.key_name}"
    security_groups = ["${aws_security_group.base_security_group.name}"]
    associate_public_ip_address = true
    count = 1
    tags {
        Name = "Ubuntu launched by Terraform"
    }
}