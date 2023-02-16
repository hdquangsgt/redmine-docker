FROM centos:7.0

RUN yum install zlib-devel patch curl-devel ImageMagick-devel openssl-devel httpd-devel libtool apr-devel apr-util-devel bzip2 mysql-devel ftp wget gcc-c++ autoconf readline readline-devel zlib libyaml-devel libffi-devel make automake bison iconv-devel subversion

#   Install ruby from rvm
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN \curl -sSL https://get.rvm.io | bash -s stable --ruby
RUN source /usr/local/rvm/scripts/rvm

#   Check ruby version
RUN ruby -v

RUN cd /var/www/
RUN svn co https://svn.redmine.org/redmine/branches/3.4-stable redmine
RUN cp config/configuration.yml.example config/configuration.yml
RUN cp config/database.yml.example config/database.yml

RUN mkdir -p tmp tmp/pdf public/plugin_assets
RUN chown -R nobody:nobody files log tmp public/plugin_assets
RUN chmod -R 775 files log tmp public/plugin_assets

RUN gem install bundler
RUN bundle install --without development test
RUN bundle exec rake generate_secret_token
