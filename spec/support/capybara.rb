require 'capybara/rspec'
require "capybara-screenshot/rspec"

Capybara::Screenshot.prune_strategy = :keep_last_run
Capybara.save_path = Rails.root.join("tmp/screenshots")

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium_chrome_headless
  end
end
