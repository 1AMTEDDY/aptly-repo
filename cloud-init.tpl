#cloud-config
runcmd:
  - [ mkdir, /mnt/${apt_dir} ]

mounts:
  - [
      "/${apt_dir}",
      "/mnt/${apt_dir}",
      cifs,
      "nofail,vers=3.0,user=${user},password=${password},serverino,gid=1000,uid=1000"
    ]
