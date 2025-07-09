provider "aws" {
  region = "us-east-1"  # Change to your desired region
}

resource "aws_key_pair" "example_keypair" {
  key_name   = "example-keypair"
  public_key = file("~/.ssh/id_rsa.pub")  # Ensure this path is correct
}

resource "aws_instance" "example_instance" {
  ami           = "ami-05ffe3c48a9991133"  # Replace with a valid AMI for your region
  instance_type = "t2.micro"
  key_name      = aws_key_pair.example_keypair.key_name

  vpc_security_group_ids = ["sg-0b6cff082b1683c71"]  # Replace with your actual SG ID

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "ExampleInstance"
  }
}

output "public_ip" {
  value = aws_instance.example_instance.public_ip
}
