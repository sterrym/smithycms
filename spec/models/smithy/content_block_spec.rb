require 'spec_helper'

describe Smithy::ContentBlock do
  it { should allow_mass_assignment_of :name }
  it { should allow_mass_assignment_of :description }
  it { should allow_mass_assignment_of :templates_attributes }

  it { should validate_presence_of :name }

  it { should accept_nested_attributes_for :templates }

  it { should have_many :templates }
end
