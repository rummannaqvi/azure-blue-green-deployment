#cloud-config
package_update: true
packages:
  - docker.io

runcmd:
  - systemctl enable docker
  - systemctl start docker
  - docker run -d -p 80:80 ${container_image}
