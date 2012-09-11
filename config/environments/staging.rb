SampleApp::Application.configure do
  config.middleware.insert_after(::Rack::Lock,
                                 "::Rack::Auth::Basic",
                                 "Staging") do |u, p|
    [u, p] == [ENV['SITE_USERNAME'], ENV['SITE_PASSWORD']]


  end
end
