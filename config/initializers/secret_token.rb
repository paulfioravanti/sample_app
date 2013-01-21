# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.

if Rails.env.production? && ENV['SECRET_TOKEN'].blank?
  raise 'SECRET_TOKEN environment variable must be set!'
end

SampleApp::Application.config.secret_token =
  ENV['SECRET_TOKEN'] || 'aed3149b0d601995f23119eaefc43ee7ead7ed3cc2074c2d045b737e2602bf3aa01c4f317524f05b579241211010a932867f04c563482273134cfb52e50c833c'