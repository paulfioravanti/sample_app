# Ruby on Rails Tutorial: sample application
[![Build Status](https://secure.travis-ci.org/paulfioravanti/sample_app.png)](http://travis-ci.org/paulfioravanti/sample_app) [![Security Status](http://rails-brakeman.com/paulfioravanti/sample_app.png)](http://rails-brakeman.com/paulfioravanti/sample_app) [![Dependency Status](https://gemnasium.com/paulfioravanti/sample_app.png)](https://gemnasium.com/paulfioravanti/sample_app) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/paulfioravanti/sample_app)

This is the sample application for
[*Ruby on Rails Tutorial: Learn Rails by Example*](http://railstutorial.org/)
by [Michael Hartl](http://michaelhartl.com) (plus some modifications).

- This code is currently deployed [here](https://pf-sampleapp.herokuapp.com) using [Heroku](http://www.heroku.com/)
- Translation keys are currently being managed [here](http://www.localeapp.com/projects/1043) with [Localeapp](http://www.localeapp.com/).

If you find this repo useful, please help me level-up on [Coderwall](http://coderwall.com/) with an [![endorse](http://api.coderwall.com/pfioravanti/endorse.png)](http://coderwall.com/pfioravanti)

### Cloning Locally

    $ cd /tmp
    $ git clone git@github.com:paulfioravanti/sample_app.git
    $ cd sample_app
    $ cp config/application.example.yml config/application.yml
    $ bundle install
    $ bundle exec rake db:migrate
    $ bundle exec rake db:seed
    $ bundle exec rake db:test:prepare RAILS_ENV=test
    $ bundle exec rspec spec/

If you do not have [Postgresql](http://www.postgresql.org/) installed on your machine (or don't use it), change the string in [line 22 of **config/database.yml**](https://github.com/paulfioravanti/sample_app/blob/master/config/database.yml#L22) to `"sqlite"` or `"mysql"`, and set the `username` and `password` variables appropriately for your environment.

## Changes from the original tutorial content:

### User Interface
- Added [Font Awesome](http://fortawesome.github.com/Font-Awesome/) icons to the header
- Added micropost character countdown based on Twitter's
- Added an endless scroll to pages with paginated lists of users or microposts, as shown in [Railscast #114 Endless Page (revised)](http://railscasts.com/episodes/114-endless-page-revised)

### i18n
- Added locale switcher
- Internationalized app labels with translations for Japanese and Italian
- All static content internationalized in [Markdown](http://daringfireball.net/projects/markdown/) files instead of HTML/ERb files
- Added i18n-specific routing
- Added translations to dynamic data and its relevant sample data (microposts) using [Globalize3](https://github.com/svenfuchs/globalize3)

### Backend
- Moved development database over to [Postgresql](http://www.postgresql.org/) to match deployment database on Heroku.
- Changed all views from HTML/ERb to [Haml](http://haml-lang.com/)
- Refactored [SCSS](http://sass-lang.com/) files to use more mix-ins, as well as additions to add styling to the language selector
- Used [rails-timeago](https://github.com/jgraichen/rails-timeago) to do time calculation for microposts on client-side rather than server-side (replaces method calls to `time_ago_in_words`)
- Simplified implementation of most forms with [SimpleForm](https://github.com/plataformatec/simple_form)
- Used [Figaro](https://github.com/laserlemon/figaro) to handle secret keys
- Moved mass assignment handling over to [strong_parameters](https://github.com/rails/strong_parameters) in anticipation of Rails 4.  No specific tests for it yet...

### Testing/Debugging
- Internationalized [RSpec](http://rspec.info/) tests and further refactored them
- Refactored model specs to use [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers)
- Changed RSpec output to show a progress bar instead of dots using [Fuubar](https://github.com/jeffkreeftmeijer/fuubar)
- Swapped out the debug block in the footer for [rails-footnotes](https://github.com/josevalim/rails-footnotes)

### Reporting/Optimizing
- Added service hooks to [Travis CI](http://travis-ci.org/), [Rails Brakeman](http://rails-brakeman.com/), [Gemnasium](https://gemnasium.com/), [Code Climate](https://codeclimate.com), [Rails Best Practices](http://railsbp.com/).  See badges under title for details.
- Used [SimpleCov](https://github.com/colszowka/simplecov) to ensure as much test coverage as possible.  Currently at 100%.
- Used [Bullet](https://github.com/flyerhzm/bullet) to optimize queries
- Added performance monitoring with [New Relic](http://newrelic.com/)

### TODOs
- Tests for Javascript-based functionality: Follow/Unfollow button, micropost countdown, endless scroll