require 'shoulda/matchers'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
     with.test_framework :rspec
     with.library :rails
  end
end

RSpec.configure do |config|
  # NOTE: include ActiveModel matchers globally because we aslo have classes using ActiveModel in
  # folders other than `app/models`.
  config.include Shoulda::Matchers::ActiveModel
end
