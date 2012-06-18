source 'http://rubygems.org'

gem 'rails', '3.2.5'
# Twitter frameworks to make nice UI design elements
gem 'bootstrap-sass', '2.0.3.1'
gem 'bootstrap-will_paginate', '0.0.7'
# For creating bcrypt encrypted hashes for user passwords
gem 'bcrypt-ruby', '3.0.1'
gem 'jquery-rails', '2.0.2'
# For fake example users with “realistic” names/emails
gem 'faker', '1.0.1' 
# For pagination
gem 'will_paginate', '3.0.3'
# Simplify UI code
gem 'haml-rails', '0.3.4'
# To enable the use of Markdown
gem 'rdiscount', '1.6.8'
# i18n strings for default Rails
gem 'rails-i18n', '0.6.4'
# i18n for database content
gem 'globalize3', '0.2.0'
# i18n for localeapp
gem 'localeapp', '0.4.3'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  # To access Ruby objects in Javascript
  gem 'therubyracer', '0.10.1'
  gem 'sass-rails',   '3.2.5'
  gem 'coffee-rails', '3.2.2'
  # Ruby wrapper for UglifyJS JavaScript compressor.
  gem 'uglifier', '1.2.4'
end

group :development do
  # for annotating model files with their properties
  gem 'annotate', '~> 2.5.0.pre1'
  # For html/erb to haml parsing
  gem 'hpricot', '0.8.6'
  gem 'ruby_parser', '2.3.1'
end

group :development, :test do
  gem 'sqlite3', '1.3.6'
  gem 'rspec-rails', '2.10.1'
  # for autotesting with rspec
  gem 'guard-rspec', '1.1.0'
end

group :test do
  # Helps in testing by simulating how a real user would use app
  gem 'capybara', '1.1.2'
  # Use factories instead of ActiveRecord objects
  gem 'factory_girl_rails', '3.4.0'
  # Cucumber for user stories and db cleaner utility below
  gem 'cucumber-rails', '1.3.0', require: false
  gem 'database_cleaner', '0.8.0'
  # speed up test server
  gem 'spork', '1.0.0rc3'
  # guard/spork integration
  gem 'guard-spork', '1.0.1'
  # Helps in debugging tests by being able to launch browser
  gem 'launchy', '2.1.0'
  # Mac-dependent gems
  gem 'rb-fsevent', '0.9.1', require: false
  # Growl notifications
  gem 'growl', '1.0.3'
  # Test mysql on Travis CI
  gem 'mysql2', '0.3.11'
end

group :test, :production do
  # Postgres for Travis CI testing and Heroku deployment
  gem 'pg', '0.13.2'
end