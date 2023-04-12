# config valid for current version and patch releases of Capistrano
lock "~> 3.17.2"

set :application, "hobbymate"
set :repo_url, "git@github.com:stephanyRmzE/hobbymate.git"




set :deploy_to, "/home/stephany/#{fetch :application}"


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

# Define the list of files to be symlinked
append :linked_files, "config/credentials/production.key"

namespace :deploy do
  desc "Create the credentials file"
  task :create_credentials_file do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config/credentials"
      upload! "config/credentials/production.key", "#{shared_path}/config/credentials/production.key"
    end
  end
end

# Call the create_credentials_file task after `deploy:check:linked_files`
after "deploy:check:linked_files", "deploy:create_credentials_file"
