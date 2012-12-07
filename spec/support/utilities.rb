# Allow for methods in ApplicationHelper to be tested
include ApplicationHelper

def fill_in_fields(user, new_name = nil, new_email = nil)
  scope = 'activerecord.attributes.user'
  fill_in t(:name, scope: scope),     with: new_name || user.name
  fill_in t(:email, scope: scope),    with: new_email || user.email
  fill_in t(:password, scope: scope), with: user.password
  fill_in t(:password_confirmation, scope: scope), with: user.password
end

def valid_sign_in(user)
  scope = 'sessions.new'
  fill_in t(:email, scope: scope),    with: user.email
  fill_in t(:password, scope: scope), with: user.password
  click_button t(:sign_in, scope: scope)
end

def sign_in_request(locale, user)
  post sessions_path(locale, email: user.email, password: user.password)
  cookies[:remember_token] = user.remember_token
end

def invalid_email_addresses
  %w[user@foo,com user_at_foo.org example.user@foo.
    foo@bar_baz.com foo@bar+baz.com]
end

def valid_email_addresses
  %w[user@foo.com A_USER@f.b.org frst.lst@foo.jp a+b@baz.cn]
end

def t(string, options = {})
  I18n.t(string, options)
end

RSpec::Matchers::define :have_alert_message do |type, message|
  match do |page|
    page.has_selector?("div.alert.alert-#{type}", text: message)
  end
end

# This matcher exists due to a quirk in Capybara 2.0 in not recognising
# the title on a page in have_selector unlike behaviour in 1.1.3
RSpec::Matchers::define :have_title do |text|
  match do |page|
    Capybara.string(page.body).has_selector?('title', text: text)
  end
end