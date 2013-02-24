source :rubygems
ruby '1.9.3'

gem 'rails', '3.2.12'

gem 'bootstrap-will_paginate', '0.0.9'
# For creating bcrypt encrypted hashes for user passwords
gem 'bcrypt-ruby', '3.0.1'
gem 'jquery-rails', '2.2.1'
# For fake example users with “realistic” names/emails
gem 'faker', '1.1.2'
# For pagination
gem 'will_paginate', '3.0.4'
# Simplified forms
gem 'simple_form', '2.0.4'
# Simplify UI code
gem 'haml-rails', '0.4.0'
# To enable the use of Markdown
gem 'rdiscount', '2.0.7'
# i18n strings for default Rails
gem 'rails-i18n', '0.7.2'
# i18n for database content
gem 'globalize3', '0.3.0'
# i18n using Locale
gem 'localeapp', '0.6.9'
# For JQuery timeago library
gem 'rails-timeago', '2.1.1'
# For accessing i18n in js files
gem 'i18n-js', '2.1.2'
# Editing in place
gem 'best_in_place', '2.1.0'
# Develop, test (Travis CI), and deploy (Heroku) with postgres
gem 'pg', '0.14.1'
# New Relic reporting
gem 'newrelic_rpm', '3.5.7.59'
# App secret key configuration
gem 'figaro', '0.5.4'
# Rails 4 prep
gem 'strong_parameters', '0.2.0'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  # Twitter frameworks to make nice UI design elements
  gem 'bootstrap-sass', '2.3.0.1'
  gem 'sass-rails',   '3.2.6'
  gem 'coffee-rails', '3.2.2'
  # Ruby wrapper for UglifyJS JavaScript compressor.
  gem 'uglifier', '1.3.0'
  # Font Awesome fonts
  gem 'font-awesome-sass-rails', '3.0.2.2'
end

group :development do
  # for annotating model files with their properties
  gem 'annotate', '2.5.0'
  # For html/erb to haml parsing
  gem 'hpricot', '0.8.6'
  gem 'ruby_parser', '3.1.1'
  # Security checking
  # gem 'brakeman', '1.9.2'
  # Code quality
  gem 'rails_best_practices', '1.13.4'
  # Query optimization monitoring
  gem 'bullet', '4.3.0'
  # Debugging information
  gem 'rails-footnotes', '3.7.9'
  # Better error pages
  gem 'better_errors', '0.7.0'
  gem 'binding_of_caller', '0.7.1'
  # Gem for RailsPanel Chrome extension
  gem 'meta_request', '0.2.2'
end

group :development, :test do
  gem 'rspec-rails', '2.13.0'
  # for autotesting with rspec
  gem 'guard-rspec', '2.4.1'
  # Prettier RSpec output
  gem 'fuubar', '1.1.0'
  gem 'debugger', '1.3.3'
  # For deploying from Travis worker and generating
  # Figaro-based Heroku env variables
  gem 'heroku', '2.35.0'
end

group :test do
  # Helps in testing by simulating how a real user would use app
  gem 'capybara', '2.0.2'
  # Use factories instead of ActiveRecord objects
  gem 'factory_girl_rails', '4.2.1'
  gem 'shoulda-matchers', '1.4.2'
  # Cucumber for user stories and db cleaner utility below
  gem 'cucumber-rails', '1.3.0', require: false
  gem 'database_cleaner', '0.9.1'
  # speed up test server
  gem 'spork', '0.9.2'
  # guard/spork integration
  gem 'guard-spork', '1.4.2'
  # Helps in debugging tests by being able to launch browser
  gem 'launchy', '2.2.0'
  # Mac-dependent gems
  gem 'rb-fsevent', '0.9.3', require: false
  # Growl notifications
  gem 'growl', '1.0.3'
  # Code coverage reports
  gem 'simplecov', '0.7.1', require: false
  # Performance testing
  gem 'rack-perftools_profiler', require: 'rack/perftools_profiler'
  # Test other databases on Travis CI if needed
  # gem 'mysql2', '0.3.11'
  # gem 'sqlite3', '1.3.7'
end

group :test, :production do

end