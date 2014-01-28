require 'spec_helper'

# see template_container_spec for specs on auto-creating containers
# based on template content
describe Smithy::Template do
  it { should allow_mass_assignment_of :name }
  it { should allow_mass_assignment_of :content }
  it { should allow_mass_assignment_of :template_type }

  it { should validate_presence_of :name }
  it { should ensure_inclusion_of(:template_type).in_array(Smithy::Template.types) }
  it { should_not validate_presence_of(:content) }
  context "on update" do
    subject { create(:template) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of :content }
  end

  it { should have_many :pages }
  it { should have_many :containers }

  context "with connected pages" do
    let(:template) { create(:template) }
    let!(:page) { create(:page, :template => template) }
    specify { template.pages.each{|p| p.should_receive(:touch)} }
  end
end
