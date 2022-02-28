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

# run the container (if you want to expose it on 8080 for example)
docker run -d -p 8080:80 -v /path/to/host/data/:/var/www/brat/data/annotatordata --name=docker-brat docker-brat

Dont forget in /path/to/host/data to copy the three basic config files from brat : https://brat.nlplab.org/configuration.html
- tools.conf
- annotation.conf
- visual.conf

# Have fun !
