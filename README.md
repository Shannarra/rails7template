# Rails 7 Template application [![Ruby](https://github.com/Shannarra/rails7template/actions/workflows/ruby.yml/badge.svg)](https://github.com/Shannarra/rails7template/actions/workflows/ruby.yml)

This app demonstrates Rails 7 with PostgreSQL, import maps, turbo, stimulus, bootstrap and hotwire, all running in Docker.  
You can also bootstrap the application with authentication frameworks like Devise in order to ease your work. 

## Features
* Rails 7
* Ruby 3
* Bootstrap
* Dockerfile and Docker Compose configuration
* PostgreSQL database
* Redis
* GitHub Actions for
  * tests
  * Rubocop for linting
  * Security checks with [Brakeman](https://github.com/presidentbeef/brakeman) and [bundler-audit](https://github.com/rubysec/bundler-audit)
* Dependabot for automated updates

#### Optional features:
* Authentication with Devise
  * See [Devise setup](#devise-setup) for more info

## Requirements

Please ensure you are using Docker Compose V2. This project relies on the `docker compose` command, not the previous `docker-compose` standalone program.

https://docs.docker.com/compose/#compose-v2-and-the-new-docker-compose-command

Check your docker compose version with:
```
$ docker compose version
Docker Compose version v2.20.2
```

## Initial setup

You can just run the [startup.sh](https://github.com/Shannarra/rails7template/edit/master/startup.sh) script:
```console
sh ./startup.sh
```
This will bootstrap a Rails 7 application that has some sample data but misses a lot of features, for example, it has no authentication.

If you want to have built-in authentication with Devise you can do the following:

<details>
<summary> <h3>Devise setup</h3> </summary>
Setting the application up to work with Devise is very straightforward, just a single command:

```console
sh startup.sh --devise user
```

In this case, the application will be created with authentication mechanism for a model called "User".  
The given model will be created, migrated and integrated with the application upon startup.
</details>

### Extras
Using the `startup.sh` script, you can skip the next step and make it so the application starts immediately after it has been built:
```console
sh startup.sh --run # -r works as well :) 
```

If you want to learn more about this script you can just call the `--help` option.

## Running the Rails app
```console
docker compose up
```
Then just navigate to http://localhost:3000

## Running the Rails console
When the app is already running with `docker-compose` up, attach to the container:
```console
docker compose exec web bin/rails c
```

When no container running yet, start up a new one:
```console
docker compose run --rm web bin/rails c
```

## Running tests
```console
docker compose run --rm web bin/rspec
```

## Time localization
If you want to change the timezone to your specific locale you can do this very simply, just change the TIMEZONE variable in the .env file:

```console
# TODO: change to CET, EET or wherever you live
TIMEZONE=UTC
```

## Updating gems
```console
docker compose run --rm web bundle
docker compose up --build
```

## Production build

```console
docker build -f production.Dockerfile .
```

## Deployment

This app can be hosted wherever Ruby is supported and PostgreSQL databases can be provisioned.

#### Render

[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy?repo=[https://github.com/Shannarra/rails7template](https://github.com/Shannarra/rails7template))

NOTE: You will need to generate a production secret with `bin/rails secret` and set it as the `SECRET_KEY_BASE` environment variable.

## Credits/References

### Rails with Docker
* [Quickstart: Compose and Rails](https://docs.docker.com/compose/rails/)
* [Docker for Rails Developers
Build, Ship, and Run Your Applications Everywhere](https://pragprog.com/titles/ridocker/docker-for-rails-developers/)
* [Ruby on Whales:
Dockerizing Ruby and Rails development](https://evilmartians.com/chronicles/ruby-on-whales-docker-for-ruby-rails-development)
* [Original inspiration repo](https://github.com/ryanwi/rails7-on-docker)

### Rails 7 with importmaps

* [Alpha preview: Modern JavaScript in Rails 7 without Webpack](https://www.youtube.com/watch?v=PtxZvFnL2i0)

### Rails 7 with hotwire

* [Stimulus 3 + Turbo 7 = Hotwire 1.0](https://world.hey.com/dhh/stimulus-3-turbo-7-hotwire-1-0-9d507133)
* [Turbo 7](https://world.hey.com/hotwired/turbo-7-0dd7a27f)
* [Rails 7 will have three great answers to JavaScript in 2021+](https://world.hey.com/dhh/rails-7-will-have-three-great-answers-to-javascript-in-2021-8d68191b)
* [Hotwire Turbo Replacing Rails UJS](https://www.driftingruby.com/episodes/hotwire-turbo-replacing-rails-ujs)
