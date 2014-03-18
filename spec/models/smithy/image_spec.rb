require 'spec_helper'

module Smithy
  describe Image do
    include_context "acts like a content block" # see spec/support/shared_contexts
    it { should validate_presence_of :asset }
  end
end
