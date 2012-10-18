 module Tagcms
  class Template < ActiveRecord::Base
    attr_accessible :name, :content, :template_type
    validates_presence_of :name
    validates_uniqueness_of :name
    validates_presence_of :content, :on => :update
    has_many :pages

    class << self
      def types
        %w(template include)
      end
    end
  end
end
