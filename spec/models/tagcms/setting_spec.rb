require 'spec_helper'

describe Tagcms::Setting do
  it { should validate_presence_of :name }
  it { should validate_presence_of :value }
end
