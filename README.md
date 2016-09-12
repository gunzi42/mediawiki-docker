# What is Mediawiki?

![MediaWiki](https://upload.wikimedia.org/wikipedia/commons/6/64/MediaWiki_logo_without_tagline.png)

MediaWiki is a free and open-source wiki application. Originally developed by Magnus Manske and improved by Lee Daniel Crocker, it runs on many websites, including Wikipedia, Wiktionary and Wikimedia Commons. It is written in the PHP programming language and stores the contents into a database. Like WordPress, which is based on a similar licensing & architecture, it has become the dominant software in its category.

(see [here](https://wikipedia.org/wiki/MediaWiki)

# How to use this image

## Start MySQL or MariaDB

To use MediaWiki, you need a database of your choice. You may deploy [MySQL](https://registry.hub.docker.com/_/mysql/) or [MariaDB](https://registry.hub.docker.com/_/mariadb) as a separate container (see linked Docker hub pages for instructions). Of course you can also use an existing server instead.

###TL;DR

You may deploy a MariaDB container with the following command:

	docker run --name mediawiki-db -e MYSQL_ROOT_PASSWORD=mysecretpassword -d mariadb:latest


## Install and configure MediaWiki

All basic MediaWiki settings are saved to the LocalSettings.php file. If you already have such a configuration file, you may skip this step.
If you do not have this configuration file yet you need to run MediaWiki a first time to go through the guided installer.

To start the MediaWiki installer

	docker run --rm --name mediawiki-installer --link mediawiki-db:db -d gunzi/mediawiki

After that opeen a web browser and go to the docker host's server.
If you are running MediaWiki on your local system, go to [http://localhost](http://localhost).

You should see the installer which will ask a few questions, setup the database for you and create a LocalSettings.php file. You will need this file in the next step.

You may stop the container you run the installer in as follows:

	docker stop mediawiki-installer

Note: This will delete the container as well if you used the command shown above to launch the container.

## Running MediaWiki

Now you can start MediaWiki and run it normally. 
Therefore you need to mount the LocalSettings to the container. You should also provide an image folder and extension folder so that you can upload files to your Wiki and add additional extension.

	docker run --name mediawiki -v </path/to/LocalSettings.php>:/var/www/html/LocalSettings.php:ro -v </path/to/images>:/var/www/html/images -v </path/to/extensions>:/tmp/extensions --link mediawiki-db:db -p 80:80 -d gunzi/mediawiki


## Contributing

You can help make this Dockerfile better by contributing at [Github](https://github.com/gunzi42/mediawiki-docker)
