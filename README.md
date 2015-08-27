Follow these instructions at http://installrails.com
* X-code
App Store > Xcode > Install

Xcode > Preferences > Locations > Command Line Tools (Verify version)
* Homebrew
Open Terminal
```zsh
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
* Git (Register on github.com and use same email)
```zsh
brew install git
git config --global user.name "Your Actual Name"
git config --global user.email "Your Actual Email"
```
* Ruby
```zsh
\curl -L https://get.rvm.io | bash -s stable
```
close and restart terminal
```zsh
rvm use ruby --install --default
```
* Rails
```zsh
gem install rails --no-ri --no-rdoc
```
* You probably want sublime
https://www.sublimetext.com/


### Get the project
```zsh
git clone git@github.com:slek120/furima-server-rails.git
```

### Version

* Ruby 2.2.2
* Rails 4.2.1

### Setup

* Create config/database.yml with this structure

```yml
default: &default
  adapter: mysql2
  pool: 5
  timeout: 5000
  username: root
  charset: utf8mb4
  encoding: utf8mb4
  collation: utf8mb4_general_ci

development:
  <<: *default
  database: furima_development

test:
  <<: *default
  database: db/test.sqlite3

staging:
  <<: *default
  database: furima_staging
  username: furima
  password: <password>
  host: <host>

production:
  <<: *default
  database: furima_production
  username: furima
  password: <password>
  host: <host>
```

* Create config/secrets.yml with this structure

```yml
test:
  secret_key_base:         # run command "rake secret"

development:
  <<: *default
  secret_key_base:         # run command "rake secret"
  facebook_app_id:         # Facebook App ID
  facebook_app_secret:     # Facebook App Secret

staging:
  <<: *production
  secret_key_base:         # run command "rake secret"
  facebook_app_id:         # Facebook App ID
  facebook_app_secret:     # Facebook App Secret

production: &production
  <<: *default
  secret_key_base:         # run command "rake secret"
  facebook_app_id:         # Facebook App ID
  facebook_app_secret:     # Facebook App Secret
```

* Seed the database

```zsh
bin/rake db:seed
```

* Redis (optional)

```zsh
brew install redis
redis-server /usr/local/etc/redis.conf
```

* Start the server

```zsh
rails server
```
Now go to http://localhost:3000


### Web server setup

* Install yum

```zsh
sudo yum update -y
sudo yum install -y zsh git gcc patch gcc-c++ readline readline-devel zlib zlib-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison iconv-devel
```


* ruby, bundler

```zsh
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

rbenv install 2.2.2
rbenv global 2.2.2

gem install bundler --no-ri --no-rdoc
rbenv rehash
```
* nginx

```zsh
sudo vi /etc/yum.repos.d/nginx.repo
```

```repo
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/6/$basearch/
gpgcheck=0
enabled=1
```

```zsh
sudo yum install nginx -y
sudo chkconfig nginx on
```


* ImageMagic

```
sudo yum install ImageMagick ImageMagick-devel -y
```

* MySQL

```zsh
sudo yum -y install http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
sudo yum install -y mysql mysql-devel
```

* nokogiri

```zsh
sudo yum install -y libxml2-devel libxslt-devel ruby-devel
sudo yum --enablerepo=epel install -y rubygem-nokogiri
```

* Nginx settings

```zsh
sudo vi /etc/nginx/conf.d/furima-server-rails.conf
```

```vim
server_tokens off;

upstream furima.com {
  server unix:/tmp/unicorn.furima.sock;
}

server {
    listen       80;
    server_name  furima-server-rails;
    root         /usr/share/nginx/html;
    client_max_body_size 20M;

    location ~ ^/uploads/ {
        root    /home/ec2-user/furima-server-rails/current/public;
        gzip_static on; # to serve pre-gzipped version
        expires 1y;
        add_header Cache-Control public;
        add_header ETag "";
        break;
    }

    location ~ ^/assets/ {
        root     /home/ec2-user/furima-server-rails/current/public;
        gzip_static on; # to serve pre-gzipped version
        expires 1y;
        add_header Cache-Control public;
        add_header ETag "";
        break;
    }

    location = /wysiwyg.css {
      root    /home/ec2-user/furima-server-rails/current/public;
    }

    location / {
        proxy_pass http://furima.com;
    }

    location = /robots.txt {
      root    /home/ec2-user/furima-server-rails/current/public;
    }

    location = /sitemap.xml.gz {
      root    /home/ec2-user/furima-server-rails/current/public;
    }

    # redirect server error pages to the static page /40x.html
    #
    error_page  404              /404.html;
    location = /40x.html {
    }

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
    }
}
```

* nginx restart

```zsh
sudo service nginx restart

sudo chmod 755 /
chmod 755 ~
```

* Memcached

```zsh
sudo yum install memcached
sudo chkconfig memcached on
sudo service memcached start
```

* Redis

```
sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
sudo yum --enablerepo=remi install -y redis

sudo redis-server /etc/redis.conf&
sudo chkconfig redis on
```
