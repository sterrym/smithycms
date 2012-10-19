module Tagcms
  class TemplateContainer < ActiveRecord::Base
    validates_presence_of :name, :template

    belongs_to :template
    has_many :pages, :through => :template

    attr_accessible :name
  end
end
