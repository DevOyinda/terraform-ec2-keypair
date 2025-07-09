# terraform-ec2-keypair
Mini project: terraform ec2 instancee with key pair and user data

# EC2 Instance Provisioning with Terraform on AWS

This project provisions an EC2 instance on AWS using Terraform. It includes setting up an SSH key pair, launching an instance with a specified Amazon Machine Image (AMI), configuring security group access, and installing a web server using a user data script.

---

## 🛠️ Technologies Used

- **Terraform**
- **AWS EC2**
- **Amazon Linux 2**
- **Apache (httpd)**

---

## 📁 Files

- `main.tf`: Terraform configuration file
- `README.md`: Project documentation

---

## 🚀 What This Code Does

1. **Provider Configuration**  
   Sets the AWS region to `us-east-1`.

2. **Key Pair Resource**  
   Creates an EC2 key pair named `example-keypair` using the public key found at `~/.ssh/id_rsa.pub`.  

   ```bash
   aws ec2 create-key-pair --key-name example-keypair --query 'KeyMaterial' --output text --region us-east-1 > example-keypair.pem
   ```
   **Note:** If the key already exists, either:
   - Change the key name, OR
   - Import the key into Terraform using:
     ```bash
     terraform import aws_key_pair.example_keypair example-keypair
     ```

3. **EC2 Instance Resource**  
   Provisions a `t2.micro` EC2 instance using:
   - AMI: `ami-05ffe3c48a9991133` (replace with a valid AMI ID for your region if needed)
   - Key Pair: the one created above
   - Security Group: `sg-0b6cff082b1683c71` (ensure this SG allows inbound access on ports 22 and 80)

4. **User Data Script**  
   Upon instance launch, it:
   - Updates the system
   - Installs Apache (`httpd`)
   - Starts and enables the Apache service
   - Writes a "Hello World" message to `/var/www/html/index.html`

5. **Output**  
   Prints the public IP of the created EC2 instance after deployment.

---

## ✅ How to Start

### 1. Clone the repo (or create `main.tf`)
```bash
git clone <repo_url>
cd <project_directory>
touch main.tf
```
```bash
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
```
### 2. Save the file and Initialize Terraform project using `terraform init`

### 3. Apply configuration using `terraform apply` and confirm creation of EC2 instance in AWS.
![](./Images/1.%20terraform%20apply.png)

### 4. Access Apache web server on the instance using Public ip iddress.
![](./Images/2.%20public%20ip.png)