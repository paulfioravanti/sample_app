Rails::Timeago.default_options limit: proc { 20.days.ago }, nojs: true
Rails::Timeago.locales = [:en, :it, :ja]
Rails::Timeago.map_locale "en", "better/locales/en.js"
Rails::Timeago.map_locale "it", "better/locales/it.js"
Rails::Timeago.map_locale "ja", "better/locales/ja.js"