provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "node_sg" {
  name = "node-api-sg"

  ingress {
    from_port   = 6382
    to_port     = 6382
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

resource "aws_instance" "node_backend" {
  ami                    = "ami-036940a1a7418c22f" # ✅ Windows Server 2019 in ap-south-1
  instance_type          = "t3.medium"
  key_name               = "your-key-name"
  vpc_security_group_ids = [aws_security_group.node_sg.id]

  user_data = <<-EOF
              <powershell>
              Invoke-WebRequest -Uri https://nodejs.org/dist/v18.17.1/node-v18.17.1-x64.msi -OutFile C:\\nodejs.msi
              Start-Process msiexec.exe -ArgumentList '/i C:\\nodejs.msi /qn' -Wait

              git clone https://github.com/Sujatavilaskagle/node-api-terraform.git C:\\app
              cd C:\\app\\backend
              npm install

              New-NetFirewallRule -DisplayName "Allow_NodeAPI_6382" -Direction Inbound -LocalPort 6382 -Protocol TCP -Action Allow
              Start-Process "node" -ArgumentList "index.js"
              </powershell>
              EOF

  tags = {
    Name = "NodeBackendServer"
  }

  get_password_data = true
}
