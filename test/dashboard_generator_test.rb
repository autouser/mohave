require 'test_helper'
require 'generators/dashboard_generator'

class DashboardGeneratorTest < Rails::Generators::TestCase

  tests DashboardGenerator
  destination File.expand_path("../tmp", File.dirname(__FILE__))

  setup :prepare_destination

  test "dashboard generator" do
    run_generator %w(admin)
    assert_file "app/controllers/admin/dashboard_controller.rb" do |db_controller|
      assert_match /class Admin::DashboardController < Admin::BaseController/
    end
  end

end