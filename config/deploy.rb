# config valid only for current version of Capistrano
lock "3.9.0"

server '104.197.250.20', user: 'deploy', port: 22, roles: %w{web app db}
set :application, "qs-backend"
set :repo_url, "git@github.com:alex-w-k/qs-backend.git"
set :use_sudo, true


set :deploy_to, "/home/deploy/apps/qs-backend"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil


# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

append :linked_files, "config/database.yml", "config/secrets.yml"
# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 5
namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :db do
  desc 'Reset postgres db'
  task :reset do
    on primary :db do
      within current_path do
        with rails_env: fetch(:stage) do
          execute :rake, 'db:reset DISABLE_DATABASE_ENVIRONMENT_CHECK=1'
        end
      end
    end
    invoke 'puma:start'
  end
end

namespace :deploy do

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  desc 'Clobber assets'
  task :clobber_assets => [:set_rails_env] do
    on release_roles(fetch(:assets_roles)) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "assets:clobber"
        end
      end
    end
  end

  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end
