# Only bastion machine EC2 instance in the public subnet. The RDS PostgreSQL will be launched directly in the private subnet.

resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = var.bastion_security_group_ids
  key_name                    = var.key_name
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name

  user_data = file("${path.module}/bastion-init.sh")

  # Initialise SSH forwarding
  tags = { Name = "${var.env}-bastion-ec2" }
}
