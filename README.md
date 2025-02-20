Greenbone SSL Setup from scratch in Docker-Compose.yml:

It requires 2 modifications to the docker-compose.yaml and the creation of a certificate/key pair.

First find the “gsa” block in the yaml file and change the block to be like this:

 gsa:
    image: greenbone/gsa:stable
    environment:
      - GSAD_ARGS=--no-redirect
    restart: on-failure
    ports:
      - 9392:443
    volumes:
      - gvmd_socket_vol:/run/gvmd
    secrets:
      - source: server-certificate
        target: /var/lib/gvm/CA/servercert.pem
      - source: private-key
        target: /var/lib/gvm/private/CA/serverkey.pem
    depends_on:
      - gvmd
Key changes here:

First adding the environment option overrides the default passed to the gsad program (default is --http-only), this enables the SSL port, and disables the redirection on port 80, which isn’t needed and sometimes causes issues starting for reasons…
Second change the target (internal) port from 80 to 443 gsad will now listen to
Third is the addition of the secrets block to provide the container with a certificate and key, in the locations it expects them by default.
Next ADD to the bottom of the docker-compose.yaml, a block like this:

secrets:
  server-certificate:
    file: /home/vuluser/docker_keys/servercert.pem
  private-key:
    file: /home/vuluser/docker_keys/serverkey.pem
This block defines the secrets used in the gsa block. The paths here are wherever you want to put the files. They can be generated easily enough, example for cert gen:

openssl req -x509 -newkey rsa:4096 -keyout serverkey.pem -out servercert.pem -nodes -subj '/CN=localhost' -addext 'subjectAltName = DNS:localhost' -days 365

make sure to chmod 1001:1001 serverkey.pem because it defaults to 1000 which is vuluser of host machine but the container has user gsad of UID 1001 in container VM

ALL data is persistent as docker volumes and can be listed with docker volume ls

drop volume to delete - unrecoverable if this is done so backup if this step is needed in troubleshooting

Other commands:
docker-compose -f ~/greenbone-community-container/docker-compose.yml -p greenbone-community-edition down # stop all containers
docker-compose -f ~/greenbone-community-container/docker-compose.yml -p greenbone-community-edition up -d # bring up containers
docker exec -it id /bin/bash # log on to container vm for troubleshooting

# update versioning of software
docker-compose -f docker-compose.yml -p greenbone-community-edtion pull 

#update feeds
#Create vm snapshot first cause if done wrong volumes can screw up
You must run down command
Then:
docker-compose -f ~/greenbone-community-container/docker-compose.yml -p greenbone-community-edtion pull notus-data vulnerability-tests scap-data cert-bund-data report-formats data-objects
Then run up command

logs:
docker-compose -f ~/greenbone-community-container/docker-compose.yml -p greenbone-community-edtion logs -f

docker-compose -f ~/greenbone-community-container/docker-compose.yml -p greenbone-community-edtion down notus-data vulnerability-tests scap-data cert-bund-data report-formats data-objects

docker-compose -f ~/greenbone-community-container/docker-compose.yml -p greenbone-community-edtion up -d notus-data vulnerability-tests scap-data cert-bund-data report-formats data-objects
