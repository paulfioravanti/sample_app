module Utilities
  # Allow for methods in ApplicationHelper to be tested
  include ApplicationHelper

  def fill_in_fields(user, new_name = nil, new_email = nil)
    scope = 'activerecord.attributes.user'
    fill_in t(:name, scope: scope),     with: new_name || user.name
    fill_in t(:email, scope: scope),    with: new_email || user.email
    fill_in t(:password, scope: scope), with: user.password
    fill_in t(:password_confirmation, scope: scope), with: user.password
  end

  def sign_in_through_ui(user)
    scope = 'sessions.new'
    fill_in t(:email, scope: scope),    with: user.email
    fill_in t(:password, scope: scope), with: user.password
    click_button t(:sign_in, scope: scope)
  end

  def sign_in_request(locale, user)
    post session_path(locale, email: user.email, password: user.password)
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

  def locale_labels
    scope = 'layouts.locale_selector'
    [
      { label: t(:en, scope: scope), locale: 'en' },
      { label: t(:it, scope: scope), locale: 'it' },
      { label: t(:ja, scope: scope), locale: 'ja' }
    ]
  end

  RSpec::Matchers::define :have_alert_message do |type, message|
    match do |page|
      page.has_selector?("div.alert.alert-#{type}", text: message)
    end
  end
end
