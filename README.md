# Environment

* Ubuntu 14.04
* ruby 2.2.3
* rails 4.2.1
* nginx 1.8.0
* passenger 5.0.16

# Setup

[First install git, ruby, and rails](http://installrails.com/)

If you don't have mysql, install and start service

    brew install mysql
    mysql.server start

Get the project

    # Make a folder called "furima" in "Documents"
    mkdir ~/Documents/furima

    # Copy project into folder
    git clone https://github.com/slek120/furima-server-rails.git mkdir ~/Documents/furima/furima-server-rails
    
    # Change directory to project
    cd ~/Documents/furima/furima-server-rails

    # Install ruby gems necessary for project
    bundle install

    # Configure the database
    vi config/database.yml

#### database.yml

    default: &default
      adapter: mysql2
      encoding: utf8mb4
      collation: utf8mb4_bin
      pool: 5
      timeout: 5000
      port: 3306
      username: root

    # Warning: The database defined as "test" will be erased and
    # re-generated from your development database when you run "rake".
    # Do not set this db to the same as development or production.
    test:
      <<: *default
      database: db/test

    development:
      <<: *default
      database: furima_development

type ":wq" to save and quit

    # Migrate and seed the database
    rake db:migrate
    rake db:seed

    # Configure secrets
    rake secret
    # copy the output
    vi config/secrets.yml

#### secrets.yml

    test:
      secret_key_base: # the copied output from "rake secret"

    development:
      secret_key_base: # another copied output from "rake secret"

type ":wq" to save and quit

Run the server
    
    rails server

#### Test the website at [http://localhost:3000](http://localhost:3000)

# Server setup

[How To Deploy a Rails App with Passenger and Nginx on Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-deploy-a-rails-app-with-passenger-and-nginx-on-ubuntu-14-04)
[Deploying a Ruby app with Passenger to production](https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/)

## Create user

    sudo adduser furima
    sudo visudo

Find the lines

    ## Allow root to run any commands anywhere
    root    ALL=(ALL)   ALL

and add the line
    
    furima  ALL=(ALL)   ALL

ctrl-x and confirm with y to save and exit

    # Change to furima user
    su - furima

## Install development tools

    sudo apt-get update
    sudo apt-get install build-essential libssl-dev libyaml-dev libreadline-dev openssl curl git-core zlib1g-dev bison libxml2-dev libxslt1-dev libcurl4-openssl-dev nodejs libsqlite3-dev sqlite3

## Install ruby

    # rbenv
    # https://github.com/sstephenson/rbenv
    git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    type rbenv
    # => rbenv is a function

    # rbenv-build
    # https://github.com/sstephenson/ruby-build
    git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
    rbenv install 2.2.3
    rbenv global 2.2.3

    # rbenv-vars
    # https://github.com/sstephenson/rbenv-vars
    git clone https://github.com/sstephenson/rbenv-vars.git ~/.rbenv/plugins/rbenv-vars
    vi ~/.rbenv-vars

#### .rbenv-vars

    SECRET_KEY_BASE= # get secret key base by running command "rake secret"
    FACEBOOK_APP_ID= # facebook app id
    FACEBOOK_APP_SECRET= # facebook app secret
    FURIMA_DATABASE_PASSWORD= # database password

type ":wq" to save and quit

## Install passenger and nginx

[tutorial](https://www.phusionpassenger.com/library/install/nginx/install/oss/trusty/)

    # Install a PGP key
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
    sudo apt-get install -y apt-transport-https ca-certificates

    # Add phusion's APT repository
    sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main > /etc/apt/sources.list.d/passenger.list'
    sudo apt-get update

    # Install Passenger + Nginx
    sudo apt-get install -y nginx-extras passenger

    # Configure Passenger
    sudo vi /etc/nginx/conf.d/passenger.conf

#### passenger.conf

    passenger_root /usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini;
    passenger_ruby /home/furima/.rbenv/shims/ruby;
    passenger_show_version_in_header off;
    passenger_max_pool_size 10;

type ":wq" to save and quit

#### Check install

    sudo passenger-config validate-install
    sudo passenger-memory-stats
    # ---------- Nginx processes ----------
    # PID    PPID   VMSize   Private  Name
    # -------------------------------------
    # 12443  4814   60.8 MB  0.2 MB   nginx: master process /usr/sbin/nginx
    # 12538  12443  64.9 MB  5.0 MB   nginx: worker process
    # ### Processes: 3
    # ### Total private dirty RSS: 5.56 MB
    #
    # ----- Passenger processes ------
    # PID    VMSize    Private   Name
    # --------------------------------
    # 12517  83.2 MB   0.6 MB    PassengerAgent watchdog
    # 12520  266.0 MB  3.4 MB    PassengerAgent server
    # 12531  149.5 MB  1.4 MB    PassengerAgent logger

## Configure nginx

    sudo vi /etc/nginx/sites-available/default

find the lines

    listen 80 default_server;
    listen [::]:80 default_server ipv6only=on;

and comment them out

    # listen 80 default_server;
    # listen [::]:80 default_server ipv6only=on;

type ":wq" to save and quit

create new site configuration

    sudo vi /etc/nginx/sites-available/furima

#### furima

    server {
      listen 80 default_server;
      server_name www.furima.com;
      passenger_enabled on;
      passenger_app_env production;
      root /home/furima/furima-server-rails/current/public;
    }

type ":wq" to save and quit

Create a symbolic link to sites-enabled

    sudo ln -s /etc/nginx/sites-available/furima /etc/nginx/sites-enabled/furima

Restart nginx

    sudo nginx -s reload

# Deploy to server

    mina setup
    mina deploy
