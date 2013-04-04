require 'test_helper'
require 'generators/dashboard_generator'
require 'generators/dashboard/entity_generator'

class EntityGeneratorTest < Rails::Generators::TestCase

  tests Dashboard::EntityGenerator
  destination File.expand_path("../tmp", File.dirname(__FILE__))

  context "EntityGenerator" do

    setup do
      prepare_destination
    end

    context "default behavior" do

      setup do
        run_generator %w(admin users email:string:index role:string index show)
      end

      should "generate migration" do
        assert_migration "db/migrate/create_users.rb" do |content|
          assert_match /create_table :users/, content, "should define create :table"
          assert_match /t.string :email/, content, "should define :email field"
          assert_match /t.string :role/, content, "should define :role field"
          assert_match /drop_table :users/, content, "should define drop :table"
        end
      end

      should "generate model" do
        assert_file "app/models/user.rb" do |content|

          assert_match /^class User < ActiveRecord::Base/, content, "should define class"
          assert_match /attr_accessible :email, :role/, content, "should define attr_accessible"
        end
      end

      should "generate controller" do
        assert_file "app/controllers/admin/users_controller.rb" do |content|
          assert_match /^class Admin::UsersController < Admin::BaseController/, content, "should define class"
          assert_match /def index/, content, "should add index action"
          assert_match /def show/, content, "should add show action"
        end
      end

      should "generate action views" do
        assert_file "app/views/admin/users/index.html.erb" do |content|
          assert_match /<!-- View for action 'index' -->/, content, "should create view for index action"
        end
        assert_file "app/views/admin/users/show.html.erb" do |content|
          assert_match /<!-- View for action 'show' -->/, content, "should create view for show action"
        end
      end

    end

    context "skips" do
      
      should "skip migration" do
        run_generator %w(admin users email:string:index role:string index show --skip-migration)
        assert_no_migration "db/migrate/create_users.rb"     
      end

      should "skip model" do
        run_generator %w(admin users email:string:index role:string index show --skip-model)
        assert_no_file "app/models/user.rb"
      end

      should "skip controller" do
        run_generator %w(admin users email:string:index role:string index show --skip-controller)
        assert_no_file "app/controllers/admin/users_controller.rb"
        assert_no_file "app/views/admin/users/index.html.erb"
        assert_no_file "app/views/admin/users/show.html.erb"
      end

      should "skip views" do
        run_generator %w(admin users email:string:index role:string index show --skip-view)
        assert_file "app/controllers/admin/users_controller.rb"
        assert_no_file "app/views/admin/users/index.html.erb"
        assert_no_file "app/views/admin/users/show.html.erb"
      end


    end

  end

end