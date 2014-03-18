module Smithy
  class TemplateContainer < ActiveRecord::Base
    validates_presence_of :name, :template

    belongs_to :template
    has_many :pages, :through => :template

    default_scope -> { order([:position, :name]) }

    def display_name
      name.titleize
    end
  end
end
