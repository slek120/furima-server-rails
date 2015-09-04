require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)

set :domain, '52.88.0.200'
set :user, 'furima'
set :identity_file, 'furima_key.pem'
set :repository, 'https://github.com/slek120/furima-server-rails.git'

# Default environment
set :deploy_to, '/home/furima/staging'
set :rails_env, 'staging'
set :branch, 'develop'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'config/secrets.yml', 'log', '.rbenv-vars']

task :environment do
  invoke :'rbenv:load'
end

namespace :setup do
  desc "Prepares the production version on the server."
  task :production do
    set :deploy_to, '/home/furima/production'
    set :rails_env, 'production'
    set :branch, 'master'
    invoke :setup
  end

  desc "Prepares the staging version on the server."
  task :staging do
    set :deploy_to, '/home/furima/staging'
    set :rails_env, 'staging'
    set :branch, 'develop'
    invoke :setup
  end
end

namespace :deploy do
  desc "Deploys the production version to the server."
  task :production do
    set :deploy_to, '/home/furima/production'
    set :rails_env, 'production'
    set :branch, 'master'
    invoke :deploy
  end

  desc "Deploys the staging version to the server."
  task :staging do
    set :deploy_to, '/home/furima/staging'
    set :rails_env, 'staging'
    set :branch, 'develop'
    invoke :deploy
  end
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]

  queue! %[touch "#{deploy_to}/#{shared_path}/config/database.yml"]
  queue! %[touch "#{deploy_to}/#{shared_path}/config/secrets.yml"]
  queue! %[touch "#{deploy_to}/#{shared_path}/.rbenv-vars"]
  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/database.yml', 'secrets.yml', and '.rbenv-vars'."]

  queue %[
    repo_host=`echo $repo | sed -e 's/.*@//g' -e 's/:.*//g'` &&
    repo_port=`echo $repo | grep -o ':[0-9]*' | sed -e 's/://g'` &&
    if [ -z "${repo_port}" ]; then repo_port=22; fi &&
    ssh-keyscan -p $repo_port -H $repo_host >> ~/.ssh/known_hosts
  ]
end

desc "Deploys the default current version to the server."
task :deploy => :environment do
  to :before_hook do
    # Put things to run locally before ssh
  end
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    to :launch do
      queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
      queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
    end
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers
