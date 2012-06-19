module StaticPagesHelper

  def localized_page_for(action, locale)
    "#{Rails.root}/config/locales/#{action}/#{action}.#{locale.to_s}.md"
  end

end
