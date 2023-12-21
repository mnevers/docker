# Docker

greenbone-compose.yml: This is the compose yaml file provided by Greenbone team with some edits to allow self created cert/key pair with openssl to be pushed to gsad (web ui) container. My edits are end of file under secrets: and under gsad:
Greenbone team only supports HTTP and a binding of 127.0.0.1:9392:80. This was changed to 0.0.0.0:9392:443. Additontal troubleshooting was needed to be done as viewing the compose logs revealed a permission denied error where the UID in chmod of the file on the host was 1000 but the UID of the gsad user on the container vm was 1001 causing a permission denied error. This was discovered by docker exec /bin/bash to the instance id of the docker vm and viewing /etc/passwd. 
