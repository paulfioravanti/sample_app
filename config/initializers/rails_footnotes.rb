if defined?(Footnotes) && Rails.env.development?
  Footnotes.run! # first of all
  Footnotes::Notes::LogNote::LoggingExtensions.module_eval do
    def add(*args, &block)
      super
      logged_message = args[2] + "\n"
      Footnotes::Notes::LogNote.log(logged_message)
      logged_message
    end
  end

  # ... other init code
  Footnotes::Filter.prefix = 'subl://open?url=file://%s&line=%d&column=%d'
end
