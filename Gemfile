source 'https://rubygems.org'

gem 'rails', '3.2.8'

gem 'bootstrap-will_paginate', '0.0.9'
# For creating bcrypt encrypted hashes for user passwords
gem 'bcrypt-ruby', '3.0.1'
gem 'jquery-rails', '2.1.3'
# For fake example users with “realistic” names/emails
gem 'faker', '1.1.2'
# For pagination
gem 'will_paginate', '3.0.3'
# Simplified forms
gem 'simple_form', '2.0.4'
# Simplify UI code
gem 'haml-rails', '0.3.5'
# To enable the use of Markdown
gem 'rdiscount', '1.6.8'
# i18n strings for default Rails
gem 'rails-i18n', '0.7.0'
# i18n for database content
gem 'globalize3', '0.2.0'
# i18n for localeapp
gem 'localeapp', '0.6.5'
# For JQuery timeago library
gem 'rails-timeago', '1.4.2'
# For accessing i18n in js files
gem 'i18n-js', '2.1.2'
# Editing in place
gem 'best_in_place', '1.1.2'
# Develop on, and test postgres on Travis CI, and deploy on Heroku
gem 'pg', '0.14.1'
# New Relic reporting
gem 'newrelic_rpm', '3.5.0.1'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  # Twitter frameworks to make nice UI design elements
  gem 'bootstrap-sass', '2.1.1.0'
  gem 'sass-rails',   '3.2.5'
  # To access Ruby objects in Javascript
  gem 'therubyracer', '0.10.1'
  gem 'coffee-rails', '3.2.2'
  # Ruby wrapper for UglifyJS JavaScript compressor.
  gem 'uglifier', '1.3.0'
  # Font Awesome fonts
  gem 'font-awesome-sass-rails', '2.0.0.0'
end

group :development do
  # for annotating model files with their properties
  gem 'annotate', '2.5.0'
  # For html/erb to haml parsing
  gem 'hpricot', '0.8.6'
  gem 'ruby_parser', '2.3.1'
  # Security checking
  gem 'brakeman', '1.8.2'
  gem 'rails_best_practices', '1.12.0'
  # Query optimization monitoring
  gem 'bullet', '4.2.0'
  # Debugging information
  gem 'rails-footnotes', '3.7.9'
end

group :development, :test do
  gem 'rspec-rails', '2.11.4'
  # for autotesting with rspec
  gem 'guard-rspec', '2.1.1'
  # Prettier RSpec output
  gem 'fuubar', '1.1.0'
end

group :test do
  # Helps in testing by simulating how a real user would use app
  gem 'capybara', '1.1.3'
  # Use factories instead of ActiveRecord objects
  gem 'factory_girl_rails', '4.1.0'
  gem 'shoulda-matchers', '1.4.1'
  # Cucumber for user stories and db cleaner utility below
  gem 'cucumber-rails', '1.3.0', require: false
  gem 'database_cleaner', '0.9.1'
  # speed up test server
  gem 'spork', '0.9.0'
  # guard/spork integration
  gem 'guard-spork', '1.2.3'
  # Helps in debugging tests by being able to launch browser
  gem 'launchy', '2.1.2'
  # Mac-dependent gems
  gem 'rb-fsevent', '0.9.2', require: false
  # Growl notifications
  gem 'growl', '1.0.3'
  # Test mysql on Travis CI
  gem 'mysql2', '0.3.11'
  # Test sqlite3 on Travis CI
  gem 'sqlite3', '1.3.6'
  # Code coverage reports
  gem 'simplecov', '0.7.1', require: false
end

group :test, :production do

end