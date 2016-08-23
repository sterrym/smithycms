require 'rails_helper'

# see template_container_spec for specs on auto-creating containers
# based on template content
RSpec.describe Smithy::Template, :type => :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_inclusion_of(:template_type).in_array(Smithy::Template.types) }
  it { is_expected.not_to validate_presence_of(:content) }
  context "on update" do
    subject { create(:template) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:template_type) }
    it { is_expected.to validate_presence_of :content }
  end

  it { is_expected.to have_many :pages }
  it { is_expected.to have_many :containers }

  context "with connected pages" do
    let(:template) { create(:template) }
    let!(:page) { create(:page, :template => template) }
    specify { template.pages.each{|p| expect(p).to receive(:touch)} }
  end
end
