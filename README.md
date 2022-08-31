# Planning Applications API

A Rails API which will store planning application data.

| Dependency | Version |
|:-----------|:--------|
| Ruby       | 3.1.2   |
| Rails      | 7.0.3   |
| Postgresql | 14.2    |

## Getting started

### Clone the project

```sh
$ git@github.com:unboxed/planning-applications-api.git
```

### Using Docker

We recommend using [Docker Desktop][1] to get setup quickly. If you'd prefer not to use Docker then you'll need to install Ruby (3.1+) and PostgreSQL (14+).

### First Time Setup using Docker

#### Create the databases

```sh
$ docker-compose run --rm web rails db:setup
```

#### Start the services

```sh
$ docker-compose up
```

Once the services have started you can access it [here][2].

#### Tests

You can run the full test suite using following command:

```sh
$ docker-compose run --rm web rake
```

Individual specs can be run using the following command:

```sh
$ docker-compose run --rm web rspec spec/models/planning_application_spec.rb
```

#### Debugging using `binding.pry`

1. Initially we have installed pry-byebug to development and test group on our Gemfile

```ruby
group :development, :test do
  # ..
  gem 'pry-byebug'
  # ..
end
```

2. Our `docker-compose.yml` in the web container contains the following two line which this will allow shell on a running container:

```bash
web:
  ..
  ..
  tty: true
  stdin_open: true
```

3. Add binding.pry to the desired place you want to have a look on your rails code:

```ruby
def index
  binding.pry
end
```

4. Run your docker app container and get the container id

```sh
$ docker-compose up web
```

5. Open a separate terminal run `docker ps` and to get a list of active containers and get the container id:

```sh
$ docker ps
```

You will get something like that: (65f0b2c36363 is the container id of the web container)

```sh
CONTAINER ID        IMAGE                    COMMAND                  CREATED             STATUS              PORTS                    NAMES
65f0b2c36363        bops_web                 "./docker-entrypoint…"   23 minutes ago      Up 41 seconds       0.0.0.0:3000->3000/tcp   bops_web_1
bc38cc223991        postgis/postgis:latest   "docker-entrypoint.s…"   27 minutes ago      Up 5 minutes        5432/tcp                 bops_postgres_1
```

5. With container id in hand, you can attach the terminal to the docker instance to get your pry on the attached terminal:

```sh
$ docker attach 65f0b2c36363
```

#### Resetting everything

Destroy all containers:

```sh
$ docker-compose down
```

Destroy all containers and volumes: (:warning: This will delete your local databases):

```sh
$ docker-compose down -v
```

### Locally

#### Install the project's dependencies using bundler:

```sh
$ bundle install
```

#### Create the databases

```sh
$ bundle exec rails db:setup
```

#### Tests

You can run the full test suite using following command:

```sh
$ bundle exec rspec
```

#### Debugging using `binding.pry`

1. Initially we have installed pry-byebug to development and test group on our Gemfile

```ruby
group :development, :test do
  # ..
  gem 'pry-byebug'
  # ..
end
```

2. Add binding.pry to the desired place you want to have a look on your rails code:

```ruby
def index
  binding.pry
end
```

#### Start the server:

```sh
$ rails server
```

#### Start a rails console:

```sh
$ rails console
```

## Github Actions

We use Github Actions as part of our continuous integration process to build, run and test the application.

[1]: https://www.docker.com/products/docker-desktop
[2]: http://localhost:3000/
