# Ruby on Rails Tutorial: sample application

This is the sample application for
[*Ruby on Rails Tutorial: Learn Rails by Example*](http://railstutorial.org/)
by [Michael Hartl](http://michaelhartl.com) (plus some modifications).

### Changes from the original tutorial content:
- All views changed from HTML/ERb to [Haml](http://haml-lang.com/)
- Added locale switcher
- I18n of app labels with translations for Japanese and Italian
- All static content internationalized in [Markdown](http://daringfireball.net/projects/markdown/) files instead of HTML/ERb files
- [RSpec](http://rspec.info/) test i18n and further refactoring
- Addition of translations to dynamic data and its relevant sample data (microposts) using [Globalize3](https://github.com/svenfuchs/globalize3)
- Slight [SCSS](http://sass-lang.com/) refactoring to use mix-ins, and additions to add styling to the language selector

This code is currently deployed [here](https://pf-sample-app.herokuapp.com) using [Heroku](http://www.heroku.com/), and the translations keys are currently being managed [here](http://www.localeapp.com/projects/1043) with [Localeapp](http://www.localeapp.com/).

### **TODO**s:
- Try to improve the Micropost character countdown.  I'd love to be able to do proper pluralization of the text using the character count as well as change the text and count from, for example, "-2 characters remaining" to "2 characters over".  Question posted to StackOverflow [here](http://stackoverflow.com/questions/10955850/micropost-character-countdown-rails-tutorial-2nd-ed-chapter-10-exercise-7)
- Try and figure out an answer to the i18n Markup question posted [here](http://stackoverflow.com/questions/10233686/i18n-markdown-files-in-rails-3-views)
- Keep searching for a solution to the routes i18n redirect loop problem referred to [here](http://railscasts.com/episodes/138-i18n-revised?view=comments)