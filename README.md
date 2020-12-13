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

If you want to take advantage of the full convenience of Lokl, [download the
 management script](https://github.com/lokl-dev/go) or simply run:

`\sh -c "$(curl -sSl 'https://lokl.dev/go?v=4')"`

to launch the Lokl management script to start or manage new WordPress sites.

#### Container Parameters

We default to support ports in range 4000-5000.

Example run command:

*Note: assuming your Docker environment is set to not require `sudo` prefixed to
 commands, else adjust accordingly.*

```
docker run -e N="$LOKL_NAME" -e P="$LOKL_PORT" \                            
  --name="$LOKL_NAME" -p "$LOKL_PORT":"$LOKL_PORT" \                        
  -d lokl/lokl:"$LOKL_VERSION"   
```

Quickly launch a new WordPress local development environment, available at http://localhost:4000

```shell
name=clientsite1;port=4000; docker run -e N=$name -e P=$port --name=$name -p $port:$port -d lokl/lokl
```

Launch a bunch of new sites. Each site requires a unique name and port (within range `4000-5000`).

```shell
name=clientsite1;port=4000; docker run -e N=$name -e P=$port --name=$name -p $port:$port -d lokl/lokl
name=myblog;port=4001; docker run -e N=$name -e P=$port --name=$name -p $port:$port -d lokl/lokl
name=portfolio;port=4444; docker run -e N=$name -e P=$port --name=$name -p $port:$port -d lokl/lokl
name=clientsite2;port=4321; docker run -e N=$name -e P=$port --name=$name -p $port:$port -d lokl/lokl
```

These sites will then be available at:

 - http://localhost:4000
 - http://localhost:4001
 - http://localhost:4444
 - http://localhost:4321

Remembering your sites by port name is crazy, so best use Lokl's [management
 script](https://github.com/lokl-dev/go) instead!.


#### Environment Variables

* `N` - name used for your lokl subdomain and container name
* `P` - port your container will run on

#### Volumes

* No volumes. A decision to keep things simple. Use WP plugins or SSH to 
manage your backups.

#### Useful File Locations

* `/usr/html` - web root where WordPress is installed
* PHPMyAdmin - now available: open via Lokl interactive script
* Web based terminl - coming soon at mysite.localhost:port/ssh


## Built With

* List the Alpine base image
* PHP-FPM
* Nginx
* MariaDB

## Development

I've thrown some development aids into `./scripts` and `./build`, see script's
 comments for details. Things like:

 - compiling all SSG plugins from latest sources 
 - building Docker images with certain tags
 - deleting all Docker images and containers

`./scripts` mostly for scripts which get copied into the containers, with
 `./build` for scripts used during development.

### Multi-step Docker image building

#### Step 1

To allow for a faster boot time, we'll do the heavy lifting of provisioning our
 custom environment in a *base image*. This starts with a base Alpine Docker
 image and a Dockerfile, which  applies the following:

 - installs extra packages we'll need, via `apk add` or other means
 - copies files from host to image for use during first provisioning to build
 our *base* image and for subsequent running of containers using that image 

Something like:


`docker build -f php8/Dockerfile -t lokl/lokl:php8base . --force-rm --no-cache`

The result of this build step is an image tagged like `php8base`

#### Step 2

From this image, we'll run an instance from which to build our actual image,
 from which users' containers will be run.

And set our sitename to `php8base`, making it easy to rewrite later. 

`docker rm --force php8base`
`docker run -e N="php8base" -e P="3465" --name="php8base" -p "3465":"3465" -d lokl/lokl:"php8base"`

Tail logs on this to know about when it's ready:

`docker logs -f php8base`

#### Step 3

To build our new image using this container as a point in time snapshot, with
 all of our heavy provisioning done:

`docker commit php8base lokl/lokl:php8`

And there, we should our ready to run image.

#### Running the provisioned image

We want to perform the least amount of processes when a user is running the
 container for the first time. We also want to perform these modifications to
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

* [GitHub](https://github.com/lokl-dev/lokl)
* [Docker Hub](https://hub.docker.com/r/lokl/lokl/)

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


