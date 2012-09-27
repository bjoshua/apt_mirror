actions :create, :update, :destroy

attribute :repo_name, :name_attribute => true
attribute :repo_location, :kind_of => String
attribute :repo_section, :kind_of => Array
attribute :clean_location, :kind_of => String
attribute :web_directory, :kind_of => String, :default => /var/www/[:repo_name]
