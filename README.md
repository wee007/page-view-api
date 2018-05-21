# Page View API

## Context

The API is built using Ruby 2.5.0 and Rails 5.1.6.

It returns a JSON response containing the query result from Elasticsearch for given values.

## Getting Started

Install gems

`bundle`

Start up the app

`rails s -p 3000`

Go to http://localhost:3000/api/page_view) to see sample data returned from Elasticsearch.

You can run the test specs via `rspec` and a coverage report `index.html` will be created under the `coverage` directory.
