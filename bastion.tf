# bastion 인스턴스 생성
resource "aws_instance" "bastion-instance" {
  ami                         = "ami-0d59ddf55cdda6e21"
  instance_type               = "t2.micro"
  key_name                    = "${aws_key_pair.bastion-key.key_name}"
  subnet_id                   = "${aws_subnet.terraform-p.id}"
  vpc_security_group_ids      = ["${aws_security_group.terraform-bastion-sg.id}"]

  tags = {
    Name = "bastion-instance"
  }
}