require 'spec_helper'

module Smithy
  describe Image do
    it { should allow_mass_assignment_of :alternate_text }
    it { should allow_mass_assignment_of :height }
    it { should allow_mass_assignment_of :image_scaling }
    it { should allow_mass_assignment_of :link_url }
    it { should allow_mass_assignment_of :width }

    it { should validate_presence_of :asset }

    it { should have_many :page_contents }
    specify { Smithy::ContentBlocks::Registry.content_blocks.should include('Image')}

  end
end
