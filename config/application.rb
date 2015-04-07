require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'digest/sha1'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module SnapBizzMultitenant
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
    config.encoding = "utf-8"
    config.autoload_paths += %W(#{config.root}/lib)
    config.generators do |g|
      g.template_engine :erb
      g.test_framework :rspec, :fixture => true, :views => false
      g.integration_tool :rspec, :fixture => true, :views => false
      g.fixture_replacement :factory_girl, :dir => "spec/support/factories"
    end

    config.middleware.use Rack::Cors do
      allow do
        #origins 'localhost:9000', 'localhost', 'localhost:8000', '1.svsa-marketing.appspot.com'
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end
    
  end
end
module ValidatesAssociatedAttributes
  module ActiveRecord::Validations::ClassMethods
    def validates_associated_attributes(*associations)
      class_eval do
        validates_each(associations) do |record, associate_name, value|
          associates = value.respond_to?(:each) ? value : [value] # this lets you use it with both has_one and has_many
          associates.each do |associate|
            if associate && !associate.valid?
              associate.errors.each do |key, value|
                record.errors.add(key, value)
              end
            end
          end
        end
      end
    end
  end
end

class ActiveRecord::Base
  def self.method_missing(method_id, *args, &block)
    method_name = method_id.to_s
    if method_name =~ /^update_or_create_by_(.+)$/
      update_or_create($1, *args, &block)
    else
      super
    end
  end
  def self.update_or_create(search, *args, &block)
    parameters = search.split("_and_")
    params = Hash[ parameters.zip(args) ]
    obj = where(params).first || self.new(params)
    yield obj
    obj.save
    obj
  end
end