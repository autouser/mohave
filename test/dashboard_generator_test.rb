require 'test_helper'
require 'generators/dashboard_generator'

class DashboardGeneratorTest < Rails::Generators::TestCase

  tests DashboardGenerator
  destination File.expand_path("../tmp", File.dirname(__FILE__))

  context "DashboardGenerator" do
    
    setup do
      prepare_destination
    end


    context "default behavior" do

      setup do
        run_generator %w(admin)
      end

      should "generate dashboard base" do
        assert_file "app/controllers/admin/base_controller.rb" do |content|
          assert_match /^class Admin::BaseController < ApplicationController/, content, "should define class"
          assert_match /layout\s+'admin'/, content, "should add layout"
        end
      end

      should "generate dashboard controller" do
        assert_file "app/controllers/admin/dashboard_controller.rb" do |content|
          assert_instance_method :index, content
          assert_match /^class Admin::DashboardController < Admin::BaseController/, content, "should define class"
        end
      end

      should "generate dashboard layout" do
        assert_file "app/views/layouts/admin.html.erb" do |content|
          assert_match /<title>Dummy::Admin<\/title>/, content, "should set title"
          assert_match /stylesheet_link_tag\s+"admin"/, content, "should set stylesheet_link_tag"
          assert_match /javascript_include_tag\s+"admin"/, content, "should set javascript_include_tag"
        end
      end

      should "generate dashboard css" do
        assert_file "app/assets/admin.css" do |content|
          assert_match /\/\//, content, "should not be empty"
        end
      end

      should "generate dashboard javascript" do
        assert_file "app/assets/admin.js" do |content|
          assert_match /\/\*/, content, "should not be empty"
        end
      end

    end


    context "skips" do

      should "skip layout" do
        run_generator %w(admin --skip-layout)
        assert_no_file "app/views/layouts/admin.html.erb"
        assert_file "app/controllers/admin/base_controller.rb" do |content|
          assert_no_match /layout\s+'admin'/, content, "should add layout"
        end
      end

      should "skip css" do
        run_generator %w(admin --skip-css)
        assert_no_file "app/views/assets/admin.css"
        assert_file "app/views/layouts/admin.html.erb" do |content|
          assert_no_match /stylesheet_link_tag\s+"admin"/, content, "should skip stylesheet_link_tag"
        end
      end

      should "skip javascript" do
        run_generator %w(admin --skip-javascript)
        assert_no_file "app/views/assets/admin.js"
        assert_file "app/views/layouts/admin.html.erb" do |content|
          assert_no_match /javascript_include_tag\s+"admin"/, content, "should skip javascript_include_tag"
        end
      end

    end

  end

end