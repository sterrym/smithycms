module Smithy
  class ContentBlock < ActiveRecord::Base
    attr_accessible :name, :description

    validates_presence_of :name

    has_many :templates, :class_name => "ContentBlockTemplate"

    default_scope order(:name)
  end
end
