ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require "rails/generators/test_case"
require "shoulda-matchers"
require "shoulda-context"

Rails.backtrace_cleaner.remove_silencers!
