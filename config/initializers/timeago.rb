Rails::Timeago.default_options limit: proc { 20.days.ago }, nojs: true
Rails::Timeago.locales = [:en, :it, :ja]