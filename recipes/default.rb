#
# Cookbook Name:: apt-mirror
# Recipe:: default
#
# Copyright 2012, Joshua Bell
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
#
# Notes: Attribute for mirror directory

package "apt-mirror" do
  action :install
end

directory "/etc/apt/mirror.list.d" do
  mode 0755
  owner "root"
  group "root"
  action :create
end


# Move mirror creation to provider 
mirrors = data_bag('apt-mirrors')

mirrors.each do | mirror |

  template "/etc/apt/mirror.list.d/#{mirror}.list" do
    source "mirror.list.erb"
    mode 0644
    owner "root"
    group "root"
    variables(
      :type => data_bag_item("#{mirror}", 'type')
      :url => data_bag_item("#{mirror}", 'url')
      :distribution => data_bag_item("#{mirror}", 'distribution')
      :components => data_bag_item("#{mirror}", 'components')
    )
  end 

end
