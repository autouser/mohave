require 'rails/generators'

class DashboardGenerator < Rails::Generators::Base

  source_root File.expand_path('../templates', __FILE__)

  argument :name, :type => 'string', :required => true
  class_option :layout, :type => :boolean, :default => true, :description => "Generate dashboard layout"
  class_option :css, :type => :boolean, :default => true, :description => "Generate dashboard stylesheet"
  class_option :javascript, :type => :boolean, :default => true, :description => "Generate dashboard javascript"


  def create_dashboard
    template "dashboard_base.erb", "app/controllers/#{dashboard_classpath}/base_controller.rb"
    template "dashboard_controller.erb", "app/controllers/#{dashboard_classpath}/dashboard_controller.rb"
  end

  def create_layout
    if options.layout?
      template "dashboard_layout.erb", "app/views/layouts/#{dashboard_classpath}.html.erb"
    end
  end

  def create_css
    if options.css?
      template "dashboard_css.erb", "app/assets/#{dashboard_classpath}.css"
    end
  end

  def create_javascript
    if options.css?
      template "dashboard_js.erb", "app/assets/#{dashboard_classpath}.js"
    end
  end

  def create_route_warning
    verb = behavior == :invoke ? 'add to' : 'remove from'
    puts <<-TEXT

IMPORTANT INFO:

    Don't forget to #{verb} your config/routes.rb

    namespace :#{dashboard_classpath} do
      get '/' => 'dashboard#index'
    end

TEXT
  end

  private

  def has_application?
    defined?(Rails) && Rails.application ? true : false
  end

  def application_name
    has_application? ? Rails.application.class.name.split('::').first.underscore : 'application'
  end

  def test_framework
    has_application? ? Rails.application.config.generators.options[:rails][:test_framework] : nil
  end

  def orm
    has_application? ? Rails.application.config.generators.options[:rails][:orm] : nil
  end

  def dashboard_classpath
    name.underscore
  end

  def dashboard_classname
    name.camelize
  end

end