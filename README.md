# Ruby on Rails Tutorial: sample application 
[![Build Status](https://secure.travis-ci.org/paulfioravanti/sample_app.png)](http://travis-ci.org/paulfioravanti/sample_app) [![Dependency Status](https://gemnasium.com/paulfioravanti/sample_app.png)](https://gemnasium.com/paulfioravanti/sample_app)

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
- Addition of translations to dynamic data and its relevant sample data (microposts) using [Globalize3](https://github.com/svenfuchs/globalize3)
- Slight [SCSS](http://sass-lang.com/) refactoring to use mix-ins, and additions to add styling to the language selector
- Added app to [Travis CI](http://travis-ci.org/) and [Gemnasium](https://gemnasium.com/)

### **TODO**s:
- Try to improve the Micropost character countdown.  I'd love to be able to do proper pluralization of the text using the character count as well as change the text and count from, for example, "-2 characters remaining" to "2 characters over".  Question posted to StackOverflow [here](http://stackoverflow.com/q/10955850/567863)
- Keep searching for a solution to the routes i18n redirect loop problem referred to in the comments for the Railscasts i18n episode [here](http://railscasts.com/episodes/138-i18n-revised?view=comments)
- Decide whether it's worth refactoring the i18n YAML files to include dictionaries, and hence necessarily take translation keys out of Localeapp and manage them manually.  StackOverflow question about this posted [here](http://stackoverflow.com/q/11097572/567863)