# Ruby on Rails Tutorial: sample application

This is the sample application for
[*Ruby on Rails Tutorial: Learn Rails by Example*](http://railstutorial.org/)
by [Michael Hartl](http://michaelhartl.com) (plus some modifications).

### Changes from the original tutorial content:
- All views changed from HTML/ERb to [Haml](http://haml-lang.com/)
- Static content changed to come from [Markdown](http://daringfireball.net/projects/markdown/) files instead of HTML/ERb files
- I18n of app with translations for Japanese and Italian
- [RSpec](http://rspec.info/) test i18n and further refactoring
- Slight [SCSS](http://sass-lang.com/) refactoring to use mix-ins, and additions to add styling to the language selector

### **TODO**s:
- Implement Chapters 8-11 of the Rails Tutorial
- Implement i18n strategy for dynamic data (probably with Globalize3)
- Try and figure out an answer to the i18n Markup question posted [here](http://stackoverflow.com/questions/10233686/i18n-markdown-files-in-rails-3-views)
- Keep searching for a solution to the routes i18n redirect loop problem referred to [here](http://railscasts.com/episodes/138-i18n-revised?view=comments)