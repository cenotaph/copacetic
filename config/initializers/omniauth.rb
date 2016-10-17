
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Figaro.env.facebook_id, Figaro.env.facebook_secret, {:client_options => {:ssl => {:ca_path => "/etc/ssl/certs"}}}
end
