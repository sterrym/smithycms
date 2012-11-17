require 'spec_helper'

class SampleContentModel
  def self.column_names
    %w(id foo bar baz created_at updated_at)
  end
end

describe Smithy::ContentBlock do
  it { should allow_mass_assignment_of :name }
  it { should allow_mass_assignment_of :description }
  it { should allow_mass_assignment_of :templates_attributes }

  it { should validate_presence_of :name }

  it { should accept_nested_attributes_for(:templates).allow_destroy(true) }

  it { should have_many :templates }

  describe "#content_field_names" do
    let(:content_block) { FactoryGirl.create(:content_block) }
    subject { content_block.content_field_names }
    before do
      content_block.stub(:klass => SampleContentModel)
    end
    it { should == %w(foo bar baz) }
    context "when #to_liquid exists" do
      let(:sample_content_model) { SampleContentModel.new }
      subject { content_block.content_field_names }
      before do
        sample_content_model.stub(:to_liquid).and_return({
          'foo' => 'foo_value',
          'bar' => 'bar_value',
          'baz' => 'baz_value',
          'file' => 'something_else'
        })
        SampleContentModel.stub(:new).and_return(sample_content_model)
      end
      it { should == %w(foo bar baz file) }
    end
  end
end
