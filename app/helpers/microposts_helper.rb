module MicropostsHelper

  def wrap(content, sanitize = true)
    wrapped_content = content.split.map do |string|
      wrap_long_string(string)
    end.join(' ') if content

    sanitize ? sanitize(raw(wrapped_content)) : wrapped_content
  end

  private

  def wrap_long_string(text, max_width = 30)
    zero_width_space = "&#8203;"
    regex = /.{1,#{max_width}}/
    (text.length < max_width) ? text :
                                text.scan(regex).join(zero_width_space)
  end

end