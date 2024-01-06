#base image httpd
#FROM scratch for empty image
FROM httpd

MAINTAINER matt <nevers.matthew@gmail.com>

#during building of image
RUN apt-get update

#executed when container created
cmd ["echo", "Test"]

