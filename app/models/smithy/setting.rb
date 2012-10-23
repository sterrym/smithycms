module Smithy
  class Setting < ActiveRecord::Base
    attr_accessible :name, :value
    validates_presence_of :name, :value
  end
end
