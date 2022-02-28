## GET A LIGHTWEIGTH IMAGE FOR STARTING CLEAN
FROM alpine:3.7

## SETUP FOR BRAT
RUN apk add --no-cache --upgrade bash
RUN apk add --no-cache git
RUN apk add --no-cache python3
RUN apk add --no-cache sudo
RUN apk add --no-cache sed
RUN apk add --no-cache nano
RUN apk add --no-cache apache2
RUN apk update

## GET THE LATEST VERSION (AND COPY THAT TO BRAT DIRECTORY)
RUN git clone https://github.com/nlplab/brat.git /var/www/brat/
RUN sudo chmod -R 777 /var/www/brat/

## EDIT THE INSTALL SCRIPT (FORCING THE QUICK INSTALL TO IGNORE CLIENT DATA READ, AND FORCING DEFAULT USER + PASSWORD)
RUN cat /var/www/brat/install.sh | sed "s/QUICK=false/QUICK=true/g" | sed "s/user_name='default'/user_name='trs'/g" | sed "s/password=.*/password='trs'/g" > /var/www/brat/newInstall.sh
RUN mv /var/www/brat/newInstall.sh /var/www/brat/install.sh

## EXEC INSTALL (WITH FORCED ARG)
RUN sudo chmod +x /var/www/brat/install.sh
RUN /var/www/brat/install.sh

## RM THE .htaccess of brat which is annoying
RUN rm -f /var/www/brat/.htaccess

## AUTHORIZE ACCESS TO WORK AND DATA DIRECTORIES
RUN sudo chmod -R 777 /var/www/brat/data/
RUN sudo chown -R 777 /var/www/brat/work/

## ADD ANNOTATOR DATA DIR (TO SPLIT CONFIG FROM DATA WHEN RUNNING CONTAINER)
RUN sudo mkdir /var/www/brat/data/annotatordata
RUN sudo chmod -R 777 /var/www/brat/data/annotatordata/

## COPY BASIC CONFIG INTO THE ANNOTATOR DATA
RUN cp /var/www/brat/configurations/Universal-Dependencies/* /var/www/brat/data/

## CONFIGURE APACHE 2 FOR CGI AND DEFAULT BRAT DIR LOCATION
RUN cat /etc/apache2/httpd.conf | sed "s/\#LoadModule cgi_module modules\/mod_cgi.so/LoadModule cgi_module modules\/mod_cgi.so/g" | sed "s/\/var\/www\/localhost\/htdocs/\/var\/www\/brat\//g"  > /etc/apache2/tmpConf
RUN cat /etc/apache2/tmpConf | sed '/<Directory "\/var\/www\/brat\/">/,/<\/Directory>/d' | sed 's/DocumentRoot "\/var\/www\/brat\/"/DocumentRoot "\/var\/www\/brat\/" \n <Directory "\/var\/www\/brat\/">\n AllowOverride Options Indexes FileInfo Limit\n Options \+ExecCGI \n Require all granted \n AddType application\/xhtml\+xml \.xhtml \n AddType font\/ttf \.ttf \n AddHandler cgi\-script \.cgi \n <\/Directory>/g' > /etc/apache2/cleanConf
RUN mv /etc/apache2/cleanConf /etc/apache2/httpd.conf

## EXPOSE HTTP PORT
EXPOSE 80

## START APACHE 2
RUN mkdir -p /run/apache2
CMD exec /usr/sbin/httpd -D FOREGROUND
