
resource "null_resource" "deploy" {
  

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = var.EC2Key
      host        = var.EC2_APP_IP
    }

    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras enable nginx1",
      "sudo yum install -y nginx",
      "echo '<html><body><h1>Hello Application 1</h1></body></html>' | sudo tee /var/www/html/index.html",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]
  }
}