require 'spec_helper'

describe Smithy::Content do
  it { should allow_mass_assignment_of :content }
  it { should have_many :page_contents }
  specify { Smithy::ContentBlocks::Registry.content_blocks.should include('Content')}
end
