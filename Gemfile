source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.5'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'active_model_serializers', '~> 0.10.0'
gem 'rack-cors', :require => 'rack/cors'

group :development, :test do
  gem 'rspec-rails', '~> 3.5'
  gem 'byebug', platform: :mri
  gem 'pry'
  gem 'database_cleaner'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'capistrano'
  gem 'capistrano-rails', '~> 1.3'
  gem 'capistrano-rvm', '~> 0.1.0'
  gem 'capistrano-bundler'
  gem 'capistrano3-puma'
end

group :test do
  gem 'shoulda-matchers', git: 'https://github.com/thoughtbot/shoulda-matchers.git', branch: 'rails-5'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
