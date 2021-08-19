# PaperShift Base Task
## Dependencies
* Ruby version : 3.0.0
* Rails Version : 6.1.4
## Configuration
```gem install bundler && bundle install```
## Setup and Start the Applicaton
### Database Setup
```rails db:create && rails db:migrate && rails db:seed```
### Run the rails server
```rails s```
## Test Environment Setup
### Test Database Setup
```RAILS_ENV=test rails db:create && RAILS_ENV=test rails db:migrate```
### Run the Test Suit
```rspec```
