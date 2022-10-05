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
65f0b2c36363        paapi_web                 "./docker-entrypoint…"   23 minutes ago      Up 41 seconds       0.0.0.0:3000->3000/tcp   paapi_web_1
bc38cc223991        postgres/postgres:latest   "docker-entrypoint.s…"   27 minutes ago      Up 5 minutes        5432/tcp                 paapi_postgres_1
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

### Importing PlanningApplications

- Use AWS SSO to get credentials
  - https://unboxed.awsapps.com/start#/
  -> Planning Application API -> Command line or programmatic access
  1. Copy option 1: Set AWS environment variables (Option 2 probably works as well)
    export AWS_ACCESS_KEY_ID="123456"
    export AWS_SECRET_ACCESS_KEY="abcde"
    export AWS_SESSION_TOKEN="SECRET"
  2. Paste environment into terminal
  3. Verify the environment has been updated
    - `$ env`

- Run Import task
```sh
$ rake import:planning_applications LOCAL_AUTHORITY=buckinghamshire
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

## Building production docker

### Create production docker

```sh
docker build -t paapi -f Dockerfile.production .
```

### Run production docker

```sh
docker run --rm -it -p 3000:3000 -e DATABASE_URL=postgres://postgres@host.docker.internal:5432/paapi_development -e RAILS_SERVE_STATIC_FILES=true -e RAILS_ENV=production -e RAILS_LOG_TO_STDOUT=true paapi:latest bundle exec rails s
```

### Run production docker bash

```sh
docker run --rm -it -e DATABASE_URL=postgres://postgres@host.docker.internal:5432/paapi_development -e RAILS_SERVE_STATIC_FILES=true -e RAILS_ENV=production -e RAILS_LOG_TO_STDOUT=true paapi:latest /bin/bash
```

## Working with api documentation: aggregate swagger files

We need a single openapi file to exist, but to keep the code easier to maintain we have multiple files that are then compiled into this single file:

```
public/api-docs/v1/_build/swagger_doc.yaml
```

So to create a new api endpoint, create your yaml doc inside public/api-docs/v1 and reference it in

```
public/api-docs/v1/swagger_doc.yaml
```

like so:

```
  $ref: "./your_new_file_name.yaml"
```

Make changes to your new file, and when you're happy aggregate them into our single file by installing this package in your machine:

```
npm install -g swagger-cli
```

and running:

```
swagger-cli bundle public/api-docs/v1/swagger_doc.yaml --outfile public/api-docs/v1/_build/swagger_doc.yaml --type yaml
```

## Github Actions

We use Github Actions as part of our continuous integration process to build, run and test the application.

[1]: https://www.docker.com/products/docker-desktop
[2]: http://localhost:3000/
