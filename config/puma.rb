app_dir = File.expand_path("../..", __FILE__)

# Default to development
rails_env = ENV['RAILS_ENV'] || "development"
environment rails_env

if ["development"].include?(rails_env)
  workers 1
  threads 1, 3
  bind "tcp://0.0.0.0:3000"
else
  workers 3
  threads 3, 5
  bind "unix://#{app_dir}/tmp/sockets/puma.sock"
  stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true
end

pidfile "#{app_dir}/tmp/pids/puma.pid"
state_path "#{app_dir}/tmp/pids/puma.state"
activate_control_app
  
on_worker_boot do
  require "active_record"
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[rails_env])
end
