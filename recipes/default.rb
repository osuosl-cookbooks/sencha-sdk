#
# Cookbook Name:: sencha_sdk
# Recipe:: default
#
# Copyright 2014, Oregon State University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# 32-bit compatibility needs to be enabled via dpkg
# in order to run the android dev tools

bash "Enable 32 bit compatibility" do
  code <<-EOH
    dpkg --add-architecture i386
  EOH
end

# Install packages from recipes
include_recipe "apt"

# Base sources list
cookbook_file "sources.list" do
  path "/etc/apt/sources.list"
  notifies :run, 'execute[apt-get update]', :immediately
end

include_recipe "java"
include_recipe "git"
include_recipe "ant"
include_recipe "nodejs"


# Install from apt repositories
%w{libc6:i386 libncurses5:i386 libstdc++6:i386 ruby1.9.3 unzip npm xubuntu-desktop}.each do |pkg|
  package pkg do
    action :install
  end
end

# Install from npm
%w{phonegap n}.each do |pkg|
  npm_package pkg do
    action :install
  end
end 

remote_file "/tmp/sencha-cmd.zip" do
  source "http://cdn.sencha.io/cmd/5.0.0.160/SenchaCmd-5.0.0.160-linux-x64.run.zip"
  action :create
end

bash "install SenchaCmd" do
  code <<-EOH
    unzip /tmp/sencha-cmd.zip
    chmod +x SenchaCmd-5.0.0.160-linux-x64.run
    ./SenchaCmd-5.0.0.160-linux-x64.run --prefix /opt/sencha --mode unattended
  EOH
end

remote_file "/tmp/android-adt-bundle.zip" do
  source "http://dl.google.com/android/adt/adt-bundle-linux-x86_64-20140702.zip"
  action :create
end

bash "install Android ADT bundle" do
  code <<-EOH
    unzip /tmp/android-adt-bundle.zip
    mv adt-bundle-linux-x86_64-20140702/ /opt/android-adt/
    chmod 755 -R /opt/android-adt/
  EOH
end

# Add platform tools (adb, fastboot), eclipse, and Sencha to the PATH
magic_shell_environment 'PATH' do
  value '$PATH:/opt/android-adt/sdk/platform-tools:/opt/android-adt/eclipse:/opt/sencha/Sencha/Cmd/5.0.0.160'
end

remote_file "/tmp/sencha-touch.zip" do
  source "http://cdn.sencha.com/touch/sencha-touch-2.3.1a-gpl.zip"
  action :create
end

bash "install Sencha Touch SDK" do
  code <<-EOH
    unzip /tmp/sencha-touch.zip
    mv touch-2.3.1 /home/vagrant/
  EOH
end

cookbook_file "Eclipse.desktop" do
  path "/home/vagrant/Eclipse.desktop"
end

