set :stage, :production
set :rails_env, "production"

set :branch, ENV['BRANCH'] || "master"
set :deploy_to, "/home/sharetribe/web/bizaar.ca"

append :linked_files, "config/database.yml", "config/config.yml", "config/production.sphinx.conf", "config/puma.rb"
append :linked_dirs, "db/sphinx", "node_modules", "client/node_modules", "app/assets/webpack", "app/assets/javascripts/i18n", "client/app/i18n", "client/app/route", "public/assets", "public/webpack", "public/system", "log", "tmp"

server 'bizaar.ca', port: 9922, user: 'sharetribe', roles: %w{app web db}
