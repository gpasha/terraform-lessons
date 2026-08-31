#!/bin/bash

# Update the package manager
sudo yum update -y && sudo yum install -y httpd

cat <<EOF > /var/www/html/index.html
<html>
  <body>
    <h1>Deployed via Terraform</h1>
    <h2>Owner First Name: ${first_name}</h2>
    <h2>Owner Last Name: ${last_name}</h2>
    <h2>Other Names:
      %{ for name in other_names }
        <li>Hello to ${name} from ${first_name}</li>
      %{ endfor }
    </h2>
  </body>
</html>
EOF

# Start the web server
sudo service httpd start

# Enable the web server to start on boot
sudo chkconfig httpd on