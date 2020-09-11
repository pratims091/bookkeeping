# A simple bookkeeping API backend built on Rails 6  

## Run locally  
* Create `.env.development` and `.env.test` from `sample.env` 
* `bundle`or `bundle install`- to install required gems.  
* `rails db:create` - to create the required databases.  
* `rails db:migrate` - to run DB migrations.  
* `rails s` - to run the local development server.  
* `rspec` - to run the test cases.  
* `xdg-open coverage/index.html` - in debian/ubuntu to open coverage report in default browser
* `open coverage/index.html` - in Mac to open coverage report in default browser
* `rubocop` - to check the linting.  
* `rubocop -A` - to fix linting errors.  
* Import `bookkeeping.postman_collection.json` into postman to play around with the APIs 

# Todo 
* Dockerize for local development
* Add CI/CD config  
* Use [jbuilder](https://github.com/rails/jbuilder) for API response  
* Use [apipie-rails](https://github.com/Apipie/apipie-rails) for API documentation  *
* Improve this README