terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_key_pair" "example" {
  key_name   = "example-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDnKcDRgECTWJuEYKxOmrLGhiGiqAOnqG2o5NzddXNgMW2n1m8PfqkqXRyDoNON8/SVyqm1rdvfKVxi3bxuedjpW07K8meFUBUX/4/WyL+I7ijLyzrk0kEnTwamZ+miYKCqhk14PF+1h7Mq8GzcLKBLER0CHL0gNfyMO9DVhP6xFcQljGHHJ5pgvXOepjjHSuGTPIk78g2CqKDbI3fCYO8zHkruvdhVqISDFfhDF04TomH579CLb3B1GokQi7WsbdNe0dFxtoo4rty/yHScRmZKTv2PhajEvX3U9Dj9iqK4GRA7c/RWyCNbWtuwA03nItfcNHgI4h17ATTPz9P6JQnR james@Jamess-MBP"
}

resource "aws_security_group" "examplesg" {
  ingress {
# For all traffic
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]

# Restrict to web traffic
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
# to restrict ingress traffic to ssh
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "ec2_cluster" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"

  name                   = "my-cluster1"
  instance_count         = 2 

  ami                    = "ami-06fb5332e8e3e577a"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.example.id
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.examplesg.id]
  subnet_id              = "subnet-acd005e4"

  tags = { 
    Name = "IMVCS-CC-demo"
    Terraform   = "true"
    Environment = "dev"
  }
}
