##### Requirement's #####
require 'bundler/capistrano'
require 'capistrano/ext/multistage'

#### Use the asset-pipeline
load 'deploy/assets'

##### Stages #####
set :stages, %w(production staging)

##### Constant variables #####
set :application, "fairnopoly"
set :deploy_to,   "/var/www/#{application}"
set :user, "deploy"
set :use_sudo, false


##### Default variables #####
set :keep_releases, 10

##### Repository Settings #####
set :scm,        :git
set :repository, "git://github.com/fairnopoly/fairnopoly.git"

##### Additional Settings #####
#set :deploy_via, :remote_cache
set :ssh_options, { :forward_agent => true }

#### Roles #####
# See Stages

desc "tail log files"
task :log, :roles => :app do
  run "tail -f #{shared_path}/log/#{rails_env}.log" do |channel, stream, data|
    puts "#{channel[:host]}: #{data}"
    break if stream == :err
  end
end

##### Overwritten and changed default capistrano tasks #####
namespace :deploy do

  # Restart Application
  desc "Restart RailsApp"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Additional Symlinks"
  task :additional_symlink, :roles => :app do
    run "ln -nfs #{shared_path}/data/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/data/config/actionmailer.yml #{release_path}/config/actionmailer.yml"
    run "ln -nfs #{shared_path}/data/config/api.yml #{release_path}/config/api.yml"
    run "ln -nfs #{shared_path}/data/system #{release_path}/public/system"
  end

  desc "Addtional Rake Tasks"
  task :additional_rake, :roles => :app, :only => {:primary => true} do

  end

end
  
##### After and Before Tasks #####
before "deploy:assets:precompile", "deploy:additional_symlink"
after "deploy", "deploy:additional_rake"
after "deploy:restart", "deploy:cleanup"




