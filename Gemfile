source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'active_model_serializers'
gem 'bootstrap'
gem 'geokit-rails'
gem 'jquery-rails'
gem 'pg'
gem 'puma', '~> 3.11'
gem 'rack-cors', :require => 'rack/cors'
gem 'rails', '~> 5.2.2'
gem 'rest-client', '~> 2.0.2'
gem "will_paginate"

group :development, :test do
  gem 'pry', '0.11.3'
  gem 'pry-byebug', '3.6.0'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
