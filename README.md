# lokl

Instant WordPress local development for Mac, Win & Linux

## Getting Started

These instructions will cover usage information and for the docker container

### Prerequisities


In order to run this container you'll need docker installed.

* [OS X](https://docs.docker.com/mac/started/)
* [Linux](https://docs.docker.com/linux/started/)
* [Windows](https://docs.docker.com/windows/started)

### Usage

## One-line instant WordPress instance

The simplest way to get started, paste the following into a terminal to launch Lokl's interactive wizard:

`sh -c "$(curl -sSl 'https://lokl.dev/cli-5.0.0-rc2')"`

to launch the Lokl management script to start or manage new WordPress sites.

### Site templates

From version 5.0.0, Lokl now supports site template files, which, if present, Lokl will allow you to choose as a template for your new site.

Currently, these allow specifying directories from your host machine to mount within your Lokl site's container. This makes it easier for those editing plugins/themes/site files on their local computer and having the changes apply immediately within their Lokl site.

Future enhancements to this templating will allow for things like specifying different sets of plugins/themes to auto-install in new Lokl sites.

An example site template file and usage instrutions are available within the [lokl-cli](https://github.com/leonstafford/lokl-cli) repository.


#### Programmatic usage

If you're familiar with Docker and bash, you can read through the source code of this repository and the [lokl-cli](https://github.com/leonstafford/lokl-cli)'s to see how I provision and control Lokl. 

Any docs I write about that will be quickly out of date, so please refer to the code and ask me any specific questions.

#### Useful File Locations/URLs

* `/usr/html` - web root where WordPress is installed
* WordPress admin - `/wp-admin/` (username: `admin` password: `admin`)
* PHPMyAdmin - at `/phpmyadmin/` or open via Lokl interactive script
* Web based terminal - coming soon at mysite.localhost:port/ssh

## Built With/Contains

Thanks to all the people involved in these amazing open source tools!

* Alpine Linux
* PHP-FPM
* Nginx
* MariaDB
* POSIX-compliant shell scripts
* WP_CLI
* shellcheck
* shellspec
* cURL
* awk

## Development

I've thrown some development aids into `./scripts` and `./build`, see script's
 comments for details. Things like:

 - compiling all SSG plugins from latest sources 
 - building Docker images with certain tags
 - deleting all Docker images and containers

`./scripts` mostly for scripts which get copied into the containers, with
 `./build` for scripts used during development.

### Multi-step Docker image building

These are mostly notes for myself, which may be out of date. I try to scripts as much as possible vs rely on my own memory.

#### Step 1

To allow for a faster boot time, we'll do the heavy lifting of provisioning our
 custom environment in a *base image*. This starts with a base Alpine Docker
 image and a Dockerfile, which  applies the following:

 - installs extra packages we'll need, via `apk add` or other means
 - copies files from host to image for use during first provisioning to build
 our *base* image and for subsequent running of containers using that image 

 - `docker build -f php8/Dockerfile -t lokl/lokl:php8base . --force-rm --no-cache`
 - `docker build -f php7/Dockerfile -t lokl/lokl:php7base . --force-rm --no-cache`

The result of this build step is an image tagged like `php8base`

#### Step 2

From this image, we'll run an instance from which to build our actual image,
 from which users' containers will be run.

And set our sitename to `php8base`, making it easy to rewrite later. 

`docker rm --force php8base`
`docker rm --force php7base`
`docker run -e N="php8base" -e P="3465" --name="php8base" -p "3465":"3465" -d lokl/lokl:"php8base"`
`docker run -e N="php7base" -e P="3466" --name="php7base" -p "3466":"3466" -d lokl/lokl:"php7base"`

Tail logs on this to know about when it's ready:

```
Currently, output like:

Success: Activated 1 of 1 plugins.
2021/01/08 06:38:26 [notice] 70#70: using the "epoll" event method
2021/01/08 06:38:26 [notice] 70#70: nginx/1.18.0
2021/01/08 06:38:26 [notice] 70#70: OS: Linux 4.19.121-linuxkit
2021/01/08 06:38:26 [notice] 70#70: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2021/01/08 06:38:26 [notice] 70#70: start worker processes
2021/01/08 06:38:26 [notice] 70#70: start worker process 71

Can force some output to poll for, ie "Lokl php8base container has finished provisioning"
```

`docker logs -f php8base`
`docker logs -f php7base`

#### Step 3

To build our new image using this container as a point in time snapshot, with
 all of our heavy provisioning done:

`docker commit php8base lokl/lokl:php8`
`docker commit php7base lokl/lokl:php7`

And there, we should our ready to run image.

#### Running the provisioned image

[Lokl CLI](https://github.com/lokl-cli) is my client for running an interactive wizard to create and manage Lokl sites. It can be run as an interactive wizard or instantiated with variables to skip the wizard and create a new site with specific details.

I want to perform the least amount of processes when a user is running the
 container for the first time. I also want to perform these modifications to
 the container only once, including:

 - adjusting the env vars for the sitename and port from the base image's
 - adjusting the WordPress Site Name, Site URL and any references to the default
 URL from the base image
 - replacing the image's `CMD` script's contents, so that it doesn't get called
  when a user launches the container again after it's been stopped, or host
  machine rebooted.

Docker does provide the ability to modify the image's `CMD` when launching a
 container, for now, I'd prefer to keep it easy for my brain to follow along
 with things by replacing the script's contents once used, with the contents of
 other files named `second_run`, `third_run`, etc. Hmm, that didn't work, let's
 try checking for existence of some files instead...

## Find Us

Well, it's mostly [me](https://ljs.dev) at this point, no organization or company behind this project, but here are some relevant URLs:

* [GitHub](https://github.com/lokl-dev/lokl)
* [Docker Hub](https://hub.docker.com/r/lokl/lokl/)
* [Lokl homepage](https://lokl.dev)

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
substitutions, which will continue to be tweaked for keeping containers minimal.


