source 'http://rubygems.org'

gem 'rails', '3.2.3'
# Twitter frameworks to make nice UI design elements
gem 'bootstrap-sass', '2.0.0'
gem 'bootstrap-will_paginate', '0.0.5'
# For creating bcrypt encrypted hashes for user passwords
gem 'bcrypt-ruby', '3.0.1'
gem 'jquery-rails', '2.0.0'
# For fake example users with “realistic” names/emails
gem 'faker', '1.0.1' 
# For pagination
gem 'will_paginate', '3.0.3'
# Simplify UI code
gem 'haml-rails', '0.3.4'

group :development do
  gem 'sqlite3', '1.3.5'
  # for annotating model files with their properties
  gem 'annotate', '~> 2.4.1.beta'
  gem 'rspec-rails', '2.9.0'
  # For html/erb to haml parsing
  gem 'hpricot', '0.8.6'
  gem 'ruby_parser', '2.3.1'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  # To access Ruby objects in Javascript
  gem 'therubyracer'
  gem 'sass-rails',   '3.2.4'
  gem 'coffee-rails', '3.2.2'
  # Ruby wrapper for UglifyJS JavaScript compressor.
  gem 'uglifier', '1.2.3'
end

group :development, :test do
  gem 'rspec-rails', '2.9.0'
  # for autotesting
  gem 'guard-rspec', '0.5.5'
  # guard/spork integration
  gem 'guard-spork', '0.3.2'
  # speed up test server
  gem 'spork', '0.9.0'
end

group :test do
  # Helps in testing by simulating how a real user would use app
  gem 'capybara', '1.1.2'
  # Use factories instead of ActiveRecord objects
  gem 'factory_girl_rails', '1.4.0'
  # Cucumber for user stories and db cleaner utility below
  gem 'cucumber-rails', '1.2.1', require: false
  gem 'database_cleaner', '0.7.0'
  # Mac-dependent gems
  gem 'rb-fsevent', '0.4.3.1', require: false
  # Growl notifications
  gem 'growl', '1.0.3'
end

group :production do
  # Postgres for Heroku deployment
  gem 'pg', '0.12.2'
end