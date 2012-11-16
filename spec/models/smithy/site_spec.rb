require 'spec_helper'

describe Smithy::Site do
  include_context "a tree of pages" # see spec/support/shared_contexts/tree.rb

  subject { Smithy::Site.new }

  its(:root) { should == home }
  its(:to_liquid) { should == { :root => home.to_liquid }}
end