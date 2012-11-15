module Smithy
  class TemplateContainer < ActiveRecord::Base
    validates_presence_of :name, :template

    belongs_to :template
    has_many :pages, :through => :template

    attr_accessible :name

    default_scope :order => :name

    def display_name
      name.titleize
    end
  end
end
