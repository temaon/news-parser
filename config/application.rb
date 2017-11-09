require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ParserNews
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    Rails.application.config.i18n.default_locale = :ru
    Rails.application.config.autoload_paths << Rails.root.join('app/modules/**', '*.rb')
    Rails.application.config.autoload_paths += Dir[File.join(Rails.root, "lib", "ext", "*.rb")].each {|l| require l }

    config.active_job.queue_adapter = :sidekiq

    config.assets.image_optim = false
  end
end