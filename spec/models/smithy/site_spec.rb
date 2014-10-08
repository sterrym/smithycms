require 'spec_helper'

describe Smithy::Site, :type => :model do
  include_context "a tree of pages" # see spec/support/shared_contexts/tree.rb

  subject { Smithy::Site.new }

  describe '#root' do
    subject { super().root }
    it { is_expected.to eql home }
  end

  describe '#title' do
    subject { super().title }
    it { is_expected.to be_nil }
  end

  context "with a title" do
    before do
      Smithy::Site.title = 'FooBar'
    end

    describe '#title' do
      subject { super().title }
      it { is_expected.to eql 'FooBar' }
    end
    after do
      Smithy::Site.title = nil
    end
  end

  describe "#to_liquid" do
    specify "calls to_liquid on the root" do
      expect(subject.root).to receive(:to_liquid)
      subject.to_liquid
    end
  end
end
