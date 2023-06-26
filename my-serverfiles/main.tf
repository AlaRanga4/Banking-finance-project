resource "aws_instance" "test-server" {
  ami           = "ami-0477d3aed9e98876c" 
  instance_type = "t2.micro" 
  key_name = "ala"
  vpc_security_group_ids= ["sg-03164d9b2b749017f"]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    #private_key = file("./project.pem")
    private_key = file("ala.pem")
    timeout = "3m"
    agent = false
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [ "echo 'wait to start instance' "]
  }
  tags = {
    Name = "test-server"
  }
  provisioner "local-exec" {
        command = " echo ${aws_instance.test-server.public_ip} > inventory "
  }
   provisioner "local-exec" {
  command = "ansible-playbook /var/lib/jenkins/workspace/finance/my-serverfiles/finance-playbook.yml "
  } 
}
