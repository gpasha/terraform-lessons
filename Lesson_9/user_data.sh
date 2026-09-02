#!/bin/bash

dnf update -y
dnf install -y httpd

TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
PUBLIC_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4)
PRIVATE_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)

cat <<EOF > /var/www/html/index.html
<html>
  <body style="background-color: #f0f0f0; color: #333;">
    <h1>Deployed via Terraform</h1>
    <h2>Public IP: ${PUBLIC_IP}</h2>
    <h2>Private IP: ${PRIVATE_IP}</h2>
    <h3>Version: 2.0.0</h3>
  </body>
</html>
EOF

systemctl enable --now httpd
