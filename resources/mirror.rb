actions :create, :update, :destroy

attribute :name, :name_attribute => true
attribute :type, :kind_of => String
attribute :url, :kind_of => String
attribute :distribution, :kind_of => String
attribute :components, :kind_of => Array
attribute :clean, :kind_of => String
attribute :schedule, :kind_of => String
attribute :docroot, :kind_of => String, :default => /var/www/[:name]
