require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/generated_attribute'

module Dashboard
  class EntityGenerator < Rails::Generators::Base

    include Rails::Generators::Migration

    source_root File.expand_path('../templates', __FILE__)

    argument :dashboard_name, :type => 'string', :required => true
    argument :name, :type => 'string', :required => true
    argument :actions_and_fields, :type => :array, :default => [], :banner => 'controller actions and model attributes'

    class_option :controller, :type => :boolean, :default => true, :description => "Generate entity's controller"
    class_option :view, :type => :boolean, :default => true, :description => "Generate entity's controller views"
    class_option :model, :type => :boolean, :default => true, :description => "Generate entity's model"
    class_option :migration, :type => :boolean, :default => true, :description => "Generate entity's model migration"

    def process_actions_and_fields

      @actions = []
      @fields = []
      actions_and_fields.each do |arg|
        if arg.include?(':')
          @fields << Rails::Generators::GeneratedAttribute.new(*arg.split(':'))
        else
          @actions << arg
        end
      end

      @actions.uniq!
      @fields.uniq!(&:name)

    end

    def create_model
      template "model.erb", "app/models/#{model_path}.rb" if options.model?
    end

    def create_migration
      migration_template('model_migration.erb', "db/migrate/create_#{migration_path}.rb") if options.migration?
    end

    def create_controller
      template "controller.erb", "app/controllers/#{dashboard_classpath}/#{resource_path}_controller.rb" if options.controller?
    end

    def create_views
      return unless options.controller?
      if @actions.present? && options.view?
        generate_form_partial = true
        @actions.each do |action|
          @action = action
          if (%w(edit update new create).include?(action)) && generate_form_partial
            template "controller.erb", "app/views/#{dashboard_classpath}/#{resource_path}/_form.html.erb"
            generate_form_partial = false
          end
          create_file "app/views/#{dashboard_classpath}/#{resource_path}/#{action}.html.erb", "<!-- View for action '#{action}' -->"
        end
      end
    end

  def create_route
    verb = behavior == :invoke ? 'add to' : 'remove from'
    puts <<-TEXT

IMPORTANT INFO:

    Don't forget to #{verb} your #{dashboard_classpath} namespace in config/routes.rb

    resources :#{resource_path}

TEXT
  end

    def self.next_migration_number(dirname)
      if ActiveRecord::Base.timestamped_migrations
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      else
        "%.3d" % (current_migration_number(dirname) + 1)
      end
    end


    private

    def dashboard_classpath
      dashboard_name.underscore
    end

    def dashboard_classname
      dashboard_name.camelize
    end

    def resource_name
      name.camelize
    end

    def resource_path
      name.underscore
    end

    def resource_classpath
      "#{dashboard_classpath}/#{name.underscore}"
    end

    def resource_classname
      "#{dashboard_classname}::#{name.camelize}"
    end

    def fields
      @fields
    end

    def actions
      @actions
    end

    def table_name
      resource_path.gsub('/','_').pluralize
    end

    def model_path
      resource_path.underscore.singularize
    end

    def model_name
      resource_name.camelize.singularize
    end

    def migration_classname
      resource_name.delete('::')
    end

    def migration_path
      migration_classname.underscore
    end

  end
end