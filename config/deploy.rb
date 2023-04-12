# config valid for current version and patch releases of Capistrano
lock "~> 3.17.2"

set :application, "hobbymate"
set :repo_url, "git@github.com:stephanyRmzE/hobbymate.git"

set :nvm_type, :user # Or :system, depends on your deployment setup
set :nvm_node, 'v16.15.1' # Replace with the version you need



set :deploy_to, "/home/stephany/#{fetch :application}"
set :default_env, { 'SECRET_KEY_BASE' => ENV['SECRET_KEY_BASE']
}

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads'


# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system", "vendor", "storage"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
 set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
namespace :deploy do
  desc "Run seed"
  task :seed do
    on roles(:all) do
      within current_path do
        execute :bundle, :exec, 'rails', 'db:seed', 'RAILS_ENV=production'
      end
    end
  end

  after :migrating, :seed
end
