# lokl

Instant WordPress local development for Mac, Win & Linux

## Getting Started

These instructions will cover usage information and for the docker container

### Prerequisities


In order to run this container you'll need docker installed.

* [Windows](https://docs.docker.com/windows/started)
* [OS X](https://docs.docker.com/mac/started/)
* [Linux](https://docs.docker.com/linux/started/)

### Usage

#### Container Parameters

Quickly launch a new WordPress local development environment, available at http://clientsite1.localhost:4000

```shell
name=clientsite1;port=4000; docker run -e N=$name -e P=$port --name=$name -p $port:$port -d lokl/lokl
```

or with `sudo`

```shell
name=clientsite1;port=4000; sudo docker run -e N=$name -e P=$port --name=$name -p $port:$port -d lokl/lokl
```

Launch a bunch of new sites. Each site requires a unique name and port (within range `4000-5000`).

```shell
name=clientsite1;port=4000; docker run -e N=$name -e P=$port --name=$name -p $port:$port -d lokl/lokl
name=myblog;port=4001; docker run -e N=$name -e P=$port --name=$name -p $port:$port -d lokl/lokl
name=portfolio;port=4444; docker run -e N=$name -e P=$port --name=$name -p $port:$port -d lokl/lokl
name=clientsite2;port=4321; docker run -e N=$name -e P=$port --name=$name -p $port:$port -d lokl/lokl
```

These sites will then be available at:

 - http://clientsite1.localhost:4000
 - http://myblog.localhost:4001
 - http://portfolio.localhost:4444
 - http://clientsite2.localhost:4321



#### Environment Variables

* `N` - name used for your lokl subdomain and container name
* `P` - port your container will run on

#### Volumes

* No volumes. A decision to keep things simple. Use WP plugins or SSH to 
manage your backups.

#### Useful File Locations

* `/usr/html` - web root where WordPress is installed
* Web based terminl - coming soon at mysite.localhost:port/ssh
* PHPMyAdmin - coming soon at mysite.localhost:port/ssh


## Built With

* List the Alpine base image
* PHP-FPM
* Nginx
* MariaDB

## Find Us

* [GitHub](https://github.com/lokl-dev/lokl)

## Contributing

GitHub Pull Request, Issues or email Leon a diff for code/documentation.

## Versioning

Intended for use as a standalone image with everything contained (outrage!), 
so expect to use the `:latest` and not need to update it often. This is aimed 
at beginner WordPress users, as local devlopment environments without security 
concerns and management to keep things up to date done within WordPress or 
utility scripts able to be run/imported via the web terminal.

## Authors

* **Leon Stafford** - [ljs.dev](https://ljs.dev)

See also the list of [contributors](https://github.com/lokl-dev/lokl) who 
participated in this project.

## License

This project is licensed under The Unlicense - do whatever you like with it!

## Acknowledgments

* Initial prototype used copy pasta from a few GH repos as I was trying 100 
things to see if this was possible. Most of that was butchered by me and 
little remains, maybe some of the apk package choices and conf file 
substitutions, which will continue to be tweaked for most minimal containers.


