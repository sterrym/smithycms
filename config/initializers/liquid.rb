require 'tagcms/liquid/database'
Liquid::Template.file_system = Liquid::Database.new
