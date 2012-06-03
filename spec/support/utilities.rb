# Allow for methods in ApplicationHelper to be tested
include ApplicationHelper

def valid_user
  User.new(name:     "Example User", 
           email:    "user@example.com",
           password: "foobar", 
           password_confirmation: "foobar")
end

def valid_micropost(user)
  user.microposts.build(content: "Lorem Ipsum")
end

def valid_sign_up
  fill_in t('users.fields.name'),         with: "Example User"
  fill_in t('users.fields.email'),        with: "user@example.com"
  fill_in t('users.fields.password'),     with: "foobar"
  fill_in t('users.fields.confirmation'), with: "foobar"
end

def valid_sign_in(user)
  fill_in t('sessions.new.email'),    with: user.email
  fill_in t('sessions.new.password'), with: user.password
  click_button t('sessions.new.sign_in')
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token
end

def valid_update(user, new_name, new_email)
  fill_in t('users.fields.name'),         with: new_name
  fill_in t('users.fields.email'),        with: new_email
  fill_in t('users.fields.password'),     with: user.password
  fill_in t('users.fields.confirmation'), with: user.password
end

def save_user(user)
  user_with_same_email = user.dup
  user_with_same_email.email.upcase!
  user_with_same_email.save
end

def invalid_email_addresses
  %w[user@foo,com user_at_foo.org example.user@foo.
    foo@bar_baz.com foo@bar+baz.com]
end

def valid_email_addresses
  %w[user@foo.com A_USER@f.b.org frst.lst@foo.jp a+b@baz.cn]
end

def t(string, options={})
  I18n.t(string, options)
end

RSpec::Matchers::define :have_alert_message do |type, message|
  match do |page|
    page.should have_selector("div.alert.alert-#{type}", text: message)
  end
end