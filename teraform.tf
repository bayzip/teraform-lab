provider "aws" {
  region                    = "ap-southeast-1"
}

resource "aws_instance" "example" {
  ami                       = "ami-03b6f27628a4569c8"
  instance_type             = "t2.micro"
  key_name                  = "docker"
  security_groups           = [
    "sg-0559c23572f91cc97"
  ]
  subnet_id                 = "subnet-d66281b0"

  connection {
        user = "ubuntu"
        private_key = "docker.pem"
    }

  provisioner "remote-exec" {
    inline = [
          "sudo apt-get update && sudo apt-get upgrade",
          "sudo apt-get install nginx",
    ]
  }
  
  tags {
        Name = "Terraform provisioner test instance"
  }
}

output "public_ip" {
    value = "${aws_instance.example.public_ip}"
}