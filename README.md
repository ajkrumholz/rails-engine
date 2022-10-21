## Rails Engine Lite

Rails-engine-lite is a basic REST API that can provide information about items and merchants. It allows users to make HTTP requests to a number of endpoints in the API, including features to search resources by a variety of attributes.

[GitHub repository link](https://github.com/ajkrumholz/rails-engine)

### Version information

Ruby 2.7.4
Rails 5.2.8.1
PostgreSQL 1.4.4

### Setup

run the following terminal commands after pulling down the repo

```
bundle install
rails db:{create,migrate,seed}
```

### Data

Data used to seed the environment can be found here:

```
/db/data/rails-engine-development.pgdump
```

### Test suite(RSpec)

run tests in terminal using:

```
bundle exec rspec
```

---

## Merchant Endpoints

- ### get /app/v1/merchants

  Retrieve all merchants in database

- ### get /app/v1/merchants/{merchant_id}

  Retrieve basic attributes for one merchant

  ##### Path Parameters
  ||||
  |-|-|-|
  | `merchant_id` | integer | required |

- ### get /app/v1/merchants/find?name={string}

  Retrieve a single merchant matching a query string to all or part of a merchant's name

  ##### Query String
  ||||
  |-|-|-|
  | `name` | string | required |

- ### get /app/v1/merchants/find_all?name={string}

  Retrieve all merchants matching a query string to all or part of a merchant's name

  ##### Query String
  ||||
  |-|-|-|
  | `name` | string | required |


- ### get /app/v1/merchants/{merchant_id}/items

  Retrieve all items belonging to a merchant, given a merchant's ID

  ##### Path Parameters

  ||||
  |-|-|-|
  | `merchant_id` | integer | required |

----
### Item Endpoints

- ### get /app/v1/items

  Retrieve all items in database

- ### get /app/v1/items/{item_id}

  Retrieve a single item in the database by Item ID

  ##### Path Parameters
  ||||
  |-|-|-|
  | `item_id` | integer | required |


- ### post /app/v1/items/

  Create a new Item in the database

  ##### Headers
    `{ CONTENT_TYPE } => "application/json"`

  ##### Params
  |||| 
  -|-|-|
  | `name` | string | required |
  | `description` | string | required |
  | `unit_price` | decimal | required |
  | `merchant_id` | integer | required |

  ##### Example
  ```
  {
  "name": "value1",
  "description": "value2",
  "unit_price": 100.99,
  "merchant_id": 14
  }
  ```

  - ### patch /app/v1/items/{item_id}

  Update an existing Item in the database

    ##### Path Parameters
  ||||
  |-|-|-|
  | `item_id` | integer | required |

  ##### Headers
    `{ CONTENT_TYPE } => "application/json"`

  ##### Params
  |||| 
  -|-|-|
  | `name` | string | optional |
  | `description` | string | optional |
  | `unit_price` | decimal | optional |
  | `merchant_id` | integer | optional |

  ##### Example
  ```
  {
  "name": "New Name",
  "description": "New Description",
  "unit_price": 50.99,
  "merchant_id": 14
  }
  ```
  Note that while it is possible to transfer ownership of an item record to another merchant using this endpoint, expect an error if a non-existent `merchant_id` is provided.

- ### delete /app/v1/items/{item_id}

  Delete an existing Item in the database

    ##### Path Parameters
  ||||
  |-|-|-|
  | `item_id` | integer | required |

  ##### Headers
    `{ CONTENT_TYPE } => "application/json"`

- ### get /app/v1/items/find

  Two search options are available, but currently cannot be confined.

  - Search by name - returns a single item matching all or part of that items name to the provided query string.
    ##### Query String
    ||||
    |-|-|-|
    | `?name={query}` | string | required |
  - Search by price - returns a single item above a minimum price, below a maximum price, or in a range if both are provided.
    ||||
    |-|-|-|
    | `?max_price={query}` | integer | optional* |
    | `?min_price={query}` | integer | optional* |
    \* *at least one of the two options must be present*
  
    **Valid search examples**
    ```
    get /app/v1/items/find?name=ring
    get /app/v1/items/find?min_price=5
    get /app/v1/items/find?max_price=10
    get /app/v1/items/find?min_price=5&max_price=10
    ```
    **Invalid search examples**
    ```
    get /app/v1/items/find?name=ring&min_price=5
    get /app/v1/items/find?min_price=-5
    get /app/v1/items/find?min_price=15&max_price=10
    ```
- ### get /app/v1/merchants/find_all

  Retrieve all items matching a query string.

  ##### Query String
  ||||
    |-|-|-|
    | `?name={query}` | string | required |
  - Search by price - returns a single item above a minimum price, below a maximum price, or in a range if both are provided.
    ||||
    |-|-|-|
    | `?max_price={query}` | integer | optional* |
    | `?min_price={query}` | integer | optional* |
    \* *at least one of the two options must be present*
  
    **Valid search examples**
    ```
    get /app/v1/items/find_all?name=ring
    get /app/v1/items/find_all?min_price=5
    get /app/v1/items/find_all?max_price=10
    get /app/v1/items/find_all?min_price=5&max_price=10
    ```
    **Invalid search examples**
    ```
    get /app/v1/items/find_all?name=ring&min_price=5
    get /app/v1/items/find_all?min_price=-5
    get /app/v1/items/find_all?min_price=15&max_price=10

