#!/bin/bash

dnf update -y
dnf install -y httpd

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

systemctl enable --now httpd
