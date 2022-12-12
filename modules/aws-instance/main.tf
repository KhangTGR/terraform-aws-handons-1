data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "app" {
  count = var.instance_count

  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids = var.security_group_ids

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl enable httpd
    sudo systemctl start httpd
    echo "<html>
            <body>
              <a href=\"./app.html\">Click here to play!!!</a>
            </body>
          </html>" > /var/www/html/index.html
    curl "https://gist.githubusercontent.com/ZiKT1229/5935a10ce818ea7b851ea85ecf55b4da/raw/cd1119f65876d1b5db705ea2dc9097c5f5694ba5/snake.html" -o /var/www/html/app.html
    EOF


  tags = {
    Terraform   = "true"
    Project     = var.project_name
    Environment = var.environment
  }
}