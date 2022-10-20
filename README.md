## Rails Engine Lite

rails-engine-lite is a basic REST API that can provide information about items and merchants

[GitHub repository link](https://github.com/ajkrumholz/rails-engine)

### Version information
  Ruby 2.7.4
  Rails 5.2.8.1
  PostgreSQL 1.4.4

### Setup
  run the following terminal commands after pulling down the repo
    bundle install
    rails db:{create,migrate,seed}

### Data
  Data used to seed the environment can be found here:
    /db/data/rails-engine-development.pgdump

### Test suite(RSpec)
  run tests in terminal using:
    bundle exec rspec

#### rails-engine-lite allows users to make HTTP requests to a number of endpoints in the API, including features to search resources by a variety of attributes.

### Merchant Endpoints

- get /app/v1/merchants

  Retrieve all merchants in database

- get /app/v1/merchants/{merchant_id}

  Retrieve basic attributes for one merchant

  #### Path Parameters
    - merchant_id       integer       required

- get /app/v1/merchants/find?name={string}

  Retrieve a single merchant matching a query string to all or part of a merchant's name

  Query String 
    - name        string       -required

- get /app/v1/merchants/find_all?name={string}

  Retrieve all merchants matching a query string to all or part of a merchant's name

  Query String 
    - name        string       -required

- get /app/v1/merchants/{merchant_id}/items

  Retrieve all items belonging to a merchant, given a merchant's ID

  Path Parameters
    - merchant_id       integer       required

### Item Endpoints

- get /app/v1/items

  Retrieve all items in database

- get /app/v1/items/{item_id}

  Retrieve a single item in the database by Item ID

  Path Parameters
    - item_id       integer       required

- post /app/v1/items/

  Create a new Item in the database

  Headers
    - { CONTENT_TYPE } => "application/json"

  Params
    - name          string        required
    - description   string        required
    - unit_price    decimal       required
    - merchant_id   integer       required

- 
