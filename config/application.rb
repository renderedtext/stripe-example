require File.expand_path('../boot', __FILE__)

require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'active_resource/railtie'
require 'sprockets/railtie'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module StripeExample

  class Application < Rails::Application
    config.active_record.identity_map = true
    config.assets.enabled             = true
    config.assets.version             = '1.0'
    config.autoload_paths             += %W[ #{ config.root }/lib ]
    config.encoding                   = 'utf-8'
    config.filter_parameters         += [:password]
    config.i18n.default_locale        = :en
    config.sass.preferred_syntax      = :sass
    config.time_zone                  = 'Arizona'

    config.generators do |g|
      g.assets      false
      g.helper      false
      g.stylesheets false

      g.test_framework :rspec, controller_specs: false,
                               fixture:          false,
                               helper_specs:     false,
                               routing_specs:    false,
                               views:            false,
                               view_specs:       false
    end
  end

end
