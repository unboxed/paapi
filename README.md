# Planning Applications API

A Rails API which will store planning application data.

| Dependency | Version |
|:-----------|:--------|
| Ruby       | 3.1.2   |
| Rails      | 7.0.3   |
| Postgresql | 14.2    |

## Preflight

### Clone the project

```sh
$ git@github.com:unboxed/planning-applications-api.git
```

### First Time Setup

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
