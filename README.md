# docker-brat
A simple image to make a fresh install of brat

# The tool
Inspired by the fantastic tool on https://brat.nlplab.org/
See their website for more information

# Get the code !
git clone https://github.com/Heliex/docker-brat.git && cd docker-brat

# Build the image on you own
docker build . -t docker-brat (or your tag)

# Check if you have builded it correctly with
docker image ls (you shoud see the docker-brat image)

# Run the container (if you want to expose it on 8080 for example)
docker run -d -p 8080:80 -v /path/to/host/data/:/var/www/brat/data/annotatordata -v /path/to/host/cfg:/var/www/brat/data --name=docker-brat docker-brat
### Some of basics config are with this repository (in cfg folder)

# basic log & password
login : trs
password:  trs

# Have fun !
