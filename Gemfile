source 'https://rubygems.org'

gem 'rails', '>= 5.0.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# gem 'sqlite3'

#gem 'haml-rails', :group => :development 

# Gems used only for assets and not required
# in production environments by default.
#gem 'coffee-rails', :group => :development
#gem 'sass-rails', :group => :development
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
#gem 'therubyracer', :platform => :ruby
gem 'uglifier'
# use 2.0.8 because there is a bug in 2.0.9 and 2.1.0
gem "therubyracer" 
#gem "less-rails", '2.3.3' #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
#gem 'twitter-bootstrap-rails', '2.2.6'
gem "twitter-bootstrap-rails", :group => :development


#gem 'jquery-rails'

# To use ActiveModel has_secure_password
gem 'bcrypt'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
group :development do
  gem 'capistrano'
  gem 'listen'
  gem 'pry-rails'
end

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

# Gemfile for Rails 3, Sinatra, and Merb
gem 'will_paginate', '>= 3.0.5'

group :development, :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'rspec_junit_formatter'
end
group :test do
  gem 'capybara'
end
gem 'simplecov', :require => false, :group => :test

gem 'mysql2'

gem 'omniauth-github', github: 'intridea/omniauth-github'
gem 'omniauth-identity', github: 'intridea/omniauth-identity'
gem 'omniauth-twitter', github: 'arunagw/omniauth-twitter'

#
#gem 'thin'
gem 'mechanize'
gem 'nokogiri'
gem 'resque', :require => "resque/server"
#gem 'resque'
gem 'sinatra', github: 'sinatra/sinatra', branch: 'master'
gem 'ruby-readability', :require => 'readability'
gem 'responders', '~> 2.0'

# 
gem 'acts-as-taggable-on'
gem 'foreman'
gem 'puma'

#gem 'devise_token_auth'
