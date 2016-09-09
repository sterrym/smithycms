require 'rails_helper'
require 'smithy/image'
module Smithy
  RSpec.describe Image, :type => :model do
    include_context "acts like a content block" # see spec/support/shared_contexts
    it { is_expected.to validate_presence_of :asset }
  end
end
