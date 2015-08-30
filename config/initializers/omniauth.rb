OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Rails.application.secret.facebook_app_id, Rails.application.secret.facebook_app_secret
end