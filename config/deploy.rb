lock "~> 3.11.0"

set :application, "bizaar.ca"
set :repo_url, "git@gitlab-ce.roobykon.com:roobykon/bizaar.git"

set :rvm_type, :user
set :rvm_ruby_version, '2.3.4@bizaar'

set :bundle_binstubs, -> { release_path.join('bin') }
set :bundle_gemfile, -> { release_path.join('Gemfile') }
set :bundle_path, -> { shared_path.join('bundle') }
set :bundle_without, %w{test}.join(' ')  
set :bundle_flags, '--deployment'
set :npm_flags, '--silent --no-progress'
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
set :conditionally_migrate, true

set :keep_assets, 3
set :keep_releases, 3

set :format, :pretty
set :pty, true

set :rocket_chat_webhook_url, "https://rocketchat.roobykon.net/hooks/h9J7FabELEsxWKiob/wG7W7PuWNgFYNHrYN7Tqc36N5jNpsgf3sddz7cdNwqYeQtBR"

namespace :deploy do
  after :publishing, :app_restart
  desc 'restart application'
  task :app_restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "sudo service puma restart"
    end
  end
  before "deploy:app_restart", "cache:clear"
end
