require 'spec_helper'

describe Tagcms::Template do
  it { should allow_mass_assignment_of :name }
  it { should allow_mass_assignment_of :content }
  it { should allow_mass_assignment_of :template_type }

  it { should validate_presence_of :name }
  it { should ensure_inclusion_of(:template_type).in_array(Tagcms::Template.types) }
  it { should_not validate_presence_of(:content) }
  context "on update" do
    subject { FactoryGirl.create(:tagcms_template) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of :content }
  end

  it { should have_many :pages }
end
