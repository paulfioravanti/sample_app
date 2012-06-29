Rails::Timeago.default_options limit: proc { 20.days.ago }, nojs: true
Rails::Timeago.locales = [:en, :it, :ja]
Rails::Timeago.map_locale "en", "timeago/jquery.timeago.en.js"
Rails::Timeago.map_locale "it", "timeago/jquery.timeago.it.js"
Rails::Timeago.map_locale "ja", "timeago/jquery.timeago.ja.js"