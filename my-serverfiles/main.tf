resource "aws_instance" "test-server" {
  ami           = "ami-0c768662cc797cd75" 
  instance_type = "t2.micro" 
  key_name = "kittu-key"
  vpc_security_group_ids= ["sg-0025765b8d7b2983e"]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    #private_key = file("./kittu-key.pem")
    private_key = file("kittu-key.pem")
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
