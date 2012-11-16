require 'spec_helper'

module Smithy
  describe Image do
    include_context "acts like a content block" # see spec/support/shared_contexts
    it { should allow_mass_assignment_of :alternate_text }
    it { should allow_mass_assignment_of :height }
    it { should allow_mass_assignment_of :image_scaling }
    it { should allow_mass_assignment_of :link_url }
    it { should allow_mass_assignment_of :width }

    it { should validate_presence_of :asset }
  end
end
