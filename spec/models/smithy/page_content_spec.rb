require 'spec_helper'

describe Smithy::PageContent do
  it { should allow_mass_assignment_of :container }
  it { should allow_mass_assignment_of :content_block }
  it { should allow_mass_assignment_of :position }

  it { should validate_presence_of :container }
  it { should validate_presence_of :content_block }

  it { should belong_to(:page) }
  it { should belong_to(:content_block) }
end
