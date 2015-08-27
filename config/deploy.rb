# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'furima'
set :repo_url, 'git@github.com:slek120/furima-server-rails.git'

role :app, %w{furima}
role :web, %w{furima}
role :db,  %w{furima}

set :rbenv_ruby, '2.2.3'
set :user, 'ec2-user'
set :deploy_via, :remote_cache

set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  # Compresses all .js and .css files under the assets path.
  # 
  # It is important that we execute this after :normalize_assets because
  # ngx_http_gzip_static_module recommends that compressed and uncompressed
  # variants have the same mtime. Note that gzip(1) sets the mtime of the
  # compressed file after the original one automatically.
  # after :normalize_assets, :gzip_assets do
  #   on release_roles(fetch(:assets_roles)) do
  #     assets_path = release_path.join('public', fetch(:assets_prefix))
  #     within assets_path do
  #       execute :find, ". \\( -name '*.js' -o -name '*.css' \\) -exec test ! -e {}.gz \\; -print0 | xargs -r -P8 -0 gzip --keep --best --quiet"
  #     end
  #   end
  # end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute :rake, 'cache:clear'
      end
    end
  end

end
