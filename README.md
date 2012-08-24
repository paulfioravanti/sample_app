# Ruby on Rails Tutorial: sample application
[![Build Status](https://secure.travis-ci.org/paulfioravanti/sample_app.png)](http://travis-ci.org/paulfioravanti/sample_app) [![Dependency Status](https://gemnasium.com/paulfioravanti/sample_app.png)](https://gemnasium.com/paulfioravanti/sample_app)
[Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/paulfioravanti/sample_app)

This is the sample application for
[*Ruby on Rails Tutorial: Learn Rails by Example*](http://railstutorial.org/)
by [Michael Hartl](http://michaelhartl.com) (plus some modifications).

- This code is currently deployed [here](https://pf-sampleapp.herokuapp.com) using [Heroku](http://www.heroku.com/)
- Translation keys are currently being managed [here](http://www.localeapp.com/projects/1043) with [Localeapp](http://www.localeapp.com/).

### Changes from the original tutorial content:
- All views changed from HTML/ERb to [Haml](http://haml-lang.com/)
- Added locale switcher
- I18n of app labels with translations for Japanese and Italian
- All static content internationalized in [Markdown](http://daringfireball.net/projects/markdown/) files instead of HTML/ERb files
- [RSpec](http://rspec.info/) test i18n and further refactoring
- Added i18n-specific routing
- Addition of translations to dynamic data and its relevant sample data (microposts) using [Globalize3](https://github.com/svenfuchs/globalize3)
- Slight [SCSS](http://sass-lang.com/) refactoring to use mix-ins, and additions to add styling to the language selector
- Added service hooks to [Travis CI](http://travis-ci.org/), [Gemnasium](https://gemnasium.com/), [Rails Brakeman](http://rails-brakeman.com/repositories/50-paulfioravanti-sample_app), [Rails Best Practices](http://railsbp.com/repositories/197-paulfioravanti-sample_app)
- Use [rails-timeago](https://github.com/jgraichen/rails-timeago) to do time calculation for microposts on client-side rather than server-side (replaces method calls to `time_ago_in_words`)
- Refactor model specs to use [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers)