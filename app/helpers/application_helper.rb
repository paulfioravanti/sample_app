module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = t('layouts.application.base_title')
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def gravatar_link
    'http://gravatar.com/emails'
  end

  def locale_languages
    [
      { label: t('layouts.locale_selector.en'), locale: 'en' },
      { label: t('layouts.locale_selector.it'), locale: 'it' },
      { label: t('layouts.locale_selector.ja'), locale: 'ja' }
    ]
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
    # @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user?(user)
    user == current_user
  end
end