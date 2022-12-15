# app 인스턴스 생성
resource "aws_instance" "app-instance" {
  ami                         = "ami-0d59ddf55cdda6e21"
  instance_type               = "t2.micro"
  key_name                    = "${aws_key_pair.app_key.key_name}"
  subnet_id                   = "${aws_subnet.terraform-app-1.id}"
  vpc_security_group_ids      = ["${aws_security_group.terraform-app-sg.id}"]
  tags = {
    Name = "app-instance"
  }
}