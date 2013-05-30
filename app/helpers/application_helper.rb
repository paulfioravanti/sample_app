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
end