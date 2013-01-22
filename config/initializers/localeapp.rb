unless ENV["LOCALE_API_KEY"].blank?
  require 'localeapp/rails'

  Localeapp.configure do |config|
    config.api_key = ENV["LOCALE_API_KEY"]
  end
end