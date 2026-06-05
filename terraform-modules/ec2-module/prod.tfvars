aws_region       = "ap-south-1"
instance_name    = "prod-ec2"
instance_type    = "t3.small"
allowed_ssh_cidr = "0.0.0.0/0"
key_name         = "prod-keypair"
private_key_path = "./prod-keypair.pem"
volume_size      = 20
