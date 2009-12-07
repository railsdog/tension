set :application, "spreedirectory"

set :scm, :git
set :repository,  "git://github.com/railsdog/tension.git"
set :branch, "master"

set :deploy_via, :remote_cache
set :git_enable_submodules, 1
set :git_shallow_clone, 1
set :keep_releases, 5

role :web, "217.115.112.221"                   # Your HTTP server, Apache/etc
role :app, "217.115.112.221"                   # This may be the same as your `Web` server
role :db,  "217.115.112.221", :primary => true # This is where Rails migrations will run

set :use_sudo, false
set :user, "railsdog"

ssh_options[:forward_agent] = true

set :deploy_to, "/data/apps/#{application}"

namespace :deploy do
  task :start do; end
  task :stop do; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

set :shared_assets, ['config/database.yml', 'config/initializers/mail_config.rb']

namespace :spree do
  task :create_symlinks, :roles => :app do
    shared_assets.each do |asset|
      origin_path = File.join(shared_path, asset)
      destination_path = File.join(release_path, asset)
      run "ln -nsf #{origin_path} #{destination_path}"
    end
  end
end

after 'deploy:update_code', 'spree:create_symlinks'
