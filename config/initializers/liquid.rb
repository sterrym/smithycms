require 'smithy/liquid/database'
::Liquid::Template.file_system = Smithy::Liquid::Database.new
