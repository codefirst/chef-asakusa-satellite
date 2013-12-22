#
# Cookbook Name:: asakusasatellite
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

directory '/var/lib/asakusasatellite' do
  owner 'www-data'
  group 'www-data'
  mode '0755'
  action :create
end

git '/var/lib/asakusasatellite' do
  repository 'https://github.com/codefirst/AsakusaSatellite.git'
  reference 'master'
  action :checkout
  user 'www-data'
  group 'www-data'
end

gem_package "bundler" do
  action :install
end

bash 'bundle install' do
  user 'www-data'
  group 'www-data'
  cwd '/var/lib/asakusasatellite'
  code <<-EOC
    bundle install --path .bundle
  EOC
end

bash 'start asakusasatellite' do
  user 'www-data'
  group 'www-data'
  cwd '/var/lib/asakusasatellite'
  environment "PATH" => "/opt/chef/embedded/bin:#{ENV['PATH']}"
  code <<-EOC
    bundle exec thin stop
    bundle exec thin start -d
  EOC
end
