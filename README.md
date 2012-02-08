Stripe Example
==============

Reference implementation of stripe interface

## About

URLs:

- Github:             https://github.com/bm5k/stripe-example/
- Staging server:     https://stripe-example.herokuapp.com

## Configuration

You will need to add plans to your stripe account!

## Development

```bash
$ git clone git@github.com:bm5k/stripe-example.git    # clone the repo
$ cd stripe-example
$ bundle install                                      # install all dependencies, we recommend using RVM
$ cp config/database.sample.yml config/database.yml   # use the default database.yml (or customize it)
$ cp config/stripe.sample.yml config/stripe.yml       # add your own keys or you'll be sorry
$ rake db:setup                                       # creates the development database
$ ./script/server                                     # start the server
```

## Testing

Tools used:

- rspec
- capybara
- factory girl

```bash
rake spec   # this will run all of the RSpec specifications, located in ./spec
```

- Specs are organized into Models & Integration specs (/spec/models, /spec/requests)
- Model Factories are located in /spec/factories.rb

## Deployment

Recommended deployment is done via [Heroku](http://heroku.com). They have an excellent intro at http://docs.heroku.com/quickstart

### Environment Variables

Use the heroku config command to check/set environemnt variables on Heroku.

  - **STRIPE_APP_ID**: the stripe application id
  - **STRIPE_SECRET**: the stripe secret

## Credits

Developed by Dev Fu!, LLC. http://devfu.com
