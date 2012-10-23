require 'spec_helper'

describe Smithy::Setting do
  it { should validate_presence_of :name }
  it { should validate_presence_of :value }
end
