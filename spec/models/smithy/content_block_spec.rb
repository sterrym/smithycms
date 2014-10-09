require 'rails_helper'

class Smithy::SampleContentModel
  class << self
    def content_block_description
    end
  end
  def self.column_names
    %w(id foo bar baz created_at updated_at)
  end
  def to_liquid
    { 'foo' => 'foo', 'bar' => 'bar', 'baz' => 'baz' }
  end
end

RSpec.describe Smithy::ContentBlock, :type => :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to accept_nested_attributes_for(:templates).allow_destroy(true) }
  it { is_expected.to have_many :templates }

  describe "#content_field_names" do
    let(:content_block) { build(:content_block, :name => "SampleContentModel") }
    subject { content_block.content_field_names }
    it { is_expected.to eq(%w(foo bar baz)) }
    context "when #to_liquid exists" do
      let(:sample_content_model) { Smithy::SampleContentModel.new }
      subject { content_block.content_field_names }
      before do
        allow(sample_content_model).to receive(:to_liquid).and_return({
          'foo' => 'foo_value',
          'bar' => 'bar_value',
          'baz' => 'baz_value',
          'file' => 'something_else'
        })
        allow(Smithy::SampleContentModel).to receive(:new).and_return(sample_content_model)
      end
      it { is_expected.to eq(%w(foo bar baz file)) }
    end
  end
end
