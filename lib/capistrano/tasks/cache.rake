namespace :cache do
  desc "Clear Rails.cache"
  task :clear do
    on roles(:app) , in: :sequence, wait: 2 do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "cache:clear"
        end
      end
    end
  end
end
