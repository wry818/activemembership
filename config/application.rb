require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module MembershipActivation
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    # config.action_dispatch.default_headers.merge!({
#       'Access-Control-Allow-Origin' => '*',
#       'Access-Control-Request-Method' => '*'
#     });
    

# Add the fonts path
config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
config.assets.paths << Rails.root.join('app', 'assets', 'flash')

# Precompile additional assets
config.assets.precompile += %w( .svg .eot .woff .ttf .swf )


config.action_dispatch.default_headers = {
    'X-Frame-Options' => 'ALLOWALL'
}

    config.action_mailer.default_url_options = { :host => ENV['ACTION_MAILER_DEFAULT_URL'] }
    config.action_mailer.asset_host = ENV['ACTION_MAILER_DEFAULT_URL']

    # Mailgun options
    config.action_mailer.smtp_settings = {
        :authentication => :plain,
        :address => "smtp.mailgun.org",
        :port => 587,
        :domain => ENV['MAILGUN_DOMAIN'],
        :user_name => ENV['MAILGUN_USERNAME'],
        :password => ENV['MAILGUN_PASSWORD']
    }
    
    config.admin_email = ENV['ADMIN_EMAIL']
    
    config.entertainment_api_url2 = "aa"
    config.entertainment_api_url = ENV['ENTERTAINMENT_API_URL']
    config.access_code = ENV['ACCESS_CODE']
    config.how_acquired = ENV['HOW_ACQUIRED']
    
    config.shopify_url = ENV['SHOPIFY_URL']
    config.shopify_apikey = ENV['SHOPIFY_APIKEY']
    config.shopify_password = ENV['SHOPIFY_PASSWORD']
    config.shopify_activation_url = ENV['SHOPIFY_ACTIVATION_URL']
    
    config.app_name = ENV['APP_NAME']
    
  end
end
