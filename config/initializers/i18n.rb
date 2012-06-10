# encoding: utf-8
I18n.available_locales = [:en, :it, :ja]
I18n.default_locale = :en
#I18n.backend.class.send(:include, I18n::Backend::Fallbacks)
#I18n.fallbacks.map(:ja => :en)
#I18n.fallbacks.map(:it => :en)

# Application languages
LANGUAGES = [
  ['English', 'en'],
  ['Italiano', 'it'],
  ['日本語', 'ja']
]

# This method is a workaround to fix a MassAssignmentSecurity error 
# thrown for the locale variable when initializing a Micropost
Globalize::ActiveRecord::Translation.class_eval do
  attr_accessible :locale, :content
end