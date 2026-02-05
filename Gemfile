source "https://rubygems.org"

gem "rails", "~> 8.1.2" # Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "propshaft" # The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "pg", "~> 1.1" # Use postgresql as the database for Active Record
gem "puma", ">= 5.0" # Use the Puma web server [https://github.com/puma/puma]
gem "jsbundling-rails" # Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "turbo-rails" # Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "stimulus-rails" # Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "cssbundling-rails" # Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "jbuilder" # Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "redis", ">= 4.0.1" # Use Redis adapter to run Action Cable in production
gem "bcrypt", "~> 3.1.7" # Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "tzinfo-data", platforms: %i[ windows jruby ] # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "bootsnap", require: false # Reduces boot times through caching; required in config/boot.rb
gem "kamal", require: false # Deploy this application anywhere as a Docker container [https://kamal-deploy.org]]
gem "thruster", require: false # Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/
gem "image_processing", "~> 1.2" # Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "rack-cors", "~> 3.0" # Handle Cross-Origin Resource Sharing (CORS) for APIs, allowing controlled access from different domains [https://github.com/cyu/rack-cors]
gem "libreconv", "~> 0.9.5" # Convert office documents (e.g., DOC, XLS, PPT) to PDF using LibreOffice in the background [https://github.com/DocSpring/libreconv]

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude" # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "bundler-audit", require: false # Audits gems for known security defects (use config/bundler-audit.yml to ignore issues)
  gem "brakeman", require: false # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "rubocop-rails-omakase", require: false # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rspec-rails", "~> 8.0"
  gem "rswag-api", "~> 2.17"
  gem "rswag-ui", "~> 2.17"
  gem "rswag-specs", "~> 2.17"
end

group :development do
  gem "web-console" # Use console on exceptions pages [https://github.com/rails/web-console]
end

group :test do
  gem "capybara" # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "selenium-webdriver"
end
