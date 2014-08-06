# config valid only for Capistrano 3.1
lock "3.1.0"

set :application, "squash-web"
set :repo_url, "git@github.com:Spin42/squash-web.git"
set :branch, ENV["branch"] || "master"

set :deploy_to, "/home/squash-web"

set :rvm_type, :user
set :rvm_ruby_version, "jruby-1.7.130@squash-web"

set :linked_files, %w{config/database.yml config/initializers/secret_token.rb}
set :linked_dirs, %w{bin log tmp/pids}

set :keep_releases, 5

namespace :deploy do

  task :status do
    on roles(:app) do
      execute "supervisorctl status"
    end
  end

  task :start do
    on roles(:app) do
      execute "supervisorctl start #{fetch(:application)}"
    end
  end

  task :stop do
    on roles(:app) do
      execute "supervisorctl stop #{fetch(:application)}"
    end
  end

  task :restart do
    on roles(:app) do
      invoke "deploy:stop"
      invoke "deploy:start"
    end
  end

  task :update_supervisor_config do
    on roles(:app) do
      execute "supervisorctl reread"
      execute "supervisorctl update"
    end
  end

  after :publishing, :restart
  before "deploy:restart", "deploy:update_supervisor_config"
end