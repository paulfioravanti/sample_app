# Ruby on Rails Tutorial: sample application
[![Build Status](https://secure.travis-ci.org/paulfioravanti/sample_app.png)](http://travis-ci.org/paulfioravanti/sample_app) [![Security Status](http://rails-brakeman.com/paulfioravanti/sample_app.png)](http://rails-brakeman.com/paulfioravanti/sample_app) [![Dependency Status](https://gemnasium.com/paulfioravanti/sample_app.png)](https://gemnasium.com/paulfioravanti/sample_app) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/paulfioravanti/sample_app)
[![Endorse](http://api.coderwall.com/pfioravanti/endorse.png)](http://coderwall.com/pfioravanti)

This is the sample application for
[*Ruby on Rails Tutorial: Learn Rails by Example*](http://railstutorial.org/)
by [Michael Hartl](http://michaelhartl.com) (plus some modifications).

- This code is currently deployed [here](https://pf-sampleapp.herokuapp.com) using [Heroku](http://www.heroku.com/)
- Translation keys are currently being managed [here](http://www.localeapp.com/projects/1043) with [Localeapp](http://www.localeapp.com/).

### Changes from the original tutorial content:
- Moved development database over to [Postgresql](http://www.postgresql.org/) to match deployment database on Heroku.
- All views changed from HTML/ERb to [Haml](http://haml-lang.com/)
- Added [Font Awesome](http://fortawesome.github.com/Font-Awesome/) icons to the header
- Added locale switcher
- I18n of app labels with translations for Japanese and Italian
- All static content internationalized in [Markdown](http://daringfireball.net/projects/markdown/) files instead of HTML/ERb files
- [RSpec](http://rspec.info/) tests i18n-ized and further refactored
- Added i18n-specific routing
- Addition of translations to dynamic data and its relevant sample data (microposts) using [Globalize3](https://github.com/svenfuchs/globalize3)
- [SCSS](http://sass-lang.com/) refactoring to use mix-ins, and additions to add styling to the language selector
- Added service hooks to [Travis CI](http://travis-ci.org/), [Rails Brakeman](http://rails-brakeman.com/), [Gemnasium](https://gemnasium.com/), [Code Climate](https://codeclimate.com), [Rails Best Practices](http://railsbp.com/).  See badges under title for details.
- Use [SimpleCov](https://github.com/colszowka/simplecov) to ensure as much test coverage as possible.  Currently at 100%.
- Use [rails-timeago](https://github.com/jgraichen/rails-timeago) to do time calculation for microposts on client-side rather than server-side (replaces method calls to `time_ago_in_words`)
- Refactor model specs to use [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers)
- Changed out most forms to use [SimpleForm](https://github.com/plataformatec/simple_form)
- Used [Bullet](https://github.com/flyerhzm/bullet) to optimize queries