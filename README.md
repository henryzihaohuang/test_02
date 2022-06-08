# Setting up the project

1. Grab a .env file from a teammate and place it in the `recruiter` root directory
2. Install Elasticsearch, Redis, Postgres, and Heroku CLI (instructions assume you're using Homebrew)
  * Elasticsearch
    * Run `brew tap elastic/tap && brew install elastic/tap/elasticsearch-full`
    * Run the command Homebrew provides after completing installation to run Elasticsearch as a service
  * Redis
    * Run `brew install redis`
    * Run the command Homebrew provides after completing installation to run Redis as a service
  * Postgres
    * Run `brew install postgresql`
    * Run the command Homebrew provides after completing installation to run Postgres as a service
  * Heroku CLI
    * Run `brew tap heroku/brew && brew install heroku`
3. In the `recruiter` root directory
  1. Run `bundle install`
  2. Run `rails db:create db:schema:load db:seed`
  3. Run `rails db:seed RAILS_ENV=test`
6. Done!

# Running the application

`heroku local -f Procfile.development`

I like to alias this to `hld`.