FROM node:18

#Add nginx and create the run folder for nginx.
RUN \
  apt-get update && apt-get install nginx \
  \
  && mkdir -p /run/nginx

#Copy our conf into the nginx http.d folder.
COPY ingress.conf /etc/nginx/http.d/

#Launch nginx with debug options.
CMD [ "nginx","-g","daemon off;error_log /dev/stdout debug;" ]

# Create app directory
WORKDIR /usr/src/app

RUN git clone https://github.com/frangoteam/FUXA.git
WORKDIR /usr/src/app/FUXA

# Install server
WORKDIR /usr/src/app/FUXA/server
RUN sed -i '/"odbc": "2.4.9",/d' ./package.json
RUN npm install

ADD . /usr/src/app/FUXA

WORKDIR /usr/src/app/FUXA/server
# EXPOSE 1881
CMD [ "npm", "start" ]
