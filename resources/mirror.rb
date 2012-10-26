actions :create, :update, :delete

attribute :name, :name_attribute => true, :kind_of => String
attribute :type, :kind_of => String
attribute :url, :kind_of => String
attribute :distribution, :kind_of => String
attribute :components, :kind_of => Array
attribute :clean, :kind_of => String
attribute :cron, :kind_of => Boolean
attribute :schedule, :kind_of => Hash
attribute :docroot, :kind_of => String, :default => /var/www/[:name]
