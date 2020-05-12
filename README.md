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

List the different parameters available to your container

```shell
docker run give.example.org/of/your/container:v0.2.1 parameters
```

One example per permutation 

```shell
docker run give.example.org/of/your/container:v0.2.1
```

Show how to get a shell started in your container too

```shell
docker run give.example.org/of/your/container:v0.2.1 bash
```

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

* **Leon Stafford** - [ljs.de](https://ljs.dev)

See also the list of [contributors](https://github.com/lokl-dev/lokl) who 
participated in this project.

## License

This project is licensed under The Unlicense - do whatever you like with it!

## Acknowledgments

* Initial prototype used copy pasta from a few GH repos as I was trying 100 
things to see if this was possible. Most of that was butchered by me and 
little remains, maybe some of the apk package choices and conf file 
substitutions, which will continue to be tweaked for most minimal containers.


