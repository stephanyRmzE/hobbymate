# config valid for current version and patch releases of Capistrano
lock "~> 3.17.2"
require 'dotenv'
Dotenv.load('.env')


set :application, "hobbymate"
set :repo_url, "git@github.com:stephanyRmzE/hobbymate.git"


set :deploy_to, "/home/stephany/#{fetch :application}"
set :default_env, {
  'HOBBYMATE_DATABASE_PASSWORD' => ENV['HOBBYMATE_DATABASE_PASSWORD']
}

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/credentials/production.key'
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
before 'deploy:check:linked_files', :upload_files do
  on roles(:app) do
    upload!('config/database.yml', "#{shared_path}/config/database.yml")
    upload!('config/credentials/production.yml.enc', "#{release_path}/config/credentials/production.yml.enc")
    upload!('config/master.key', "#{release_path}/config/master.key")
    upload!('config/credentials.yml.enc', "#{release_path}/config/credentials.yml.enc")
  end
end 

namespace :deploy do
  desc 'Create, migrate, and seed the database'
  task :create_migrate_seed_db do
    on roles(:db) do |host|
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:create'
          execute :rake, 'db:migrate'
          execute :rake, 'db:seed'
        end
      end
    end
  end
end

before 'deploy:assets:precompile', 'deploy:create_migrate_seed_db'

namespace :deploy do
  desc "Edit Rails credentials file on remote server"
  task :edit_credentials do
    on roles(:app) do |host|
      execute :bash, '-c', 'EDITOR=nano bin/rails credentials:edit'
    end
  end
end
