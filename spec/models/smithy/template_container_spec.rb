require 'spec_helper'

describe Smithy::TemplateContainer do
  let(:one_container) { File.read(Smithy::Engine.root.join('spec', 'fixtures', 'templates', 'foo.html.liquid')) }
  let(:three_containers) { File.read(Smithy::Engine.root.join('spec', 'fixtures', 'templates', 'foo_bar_baz.html.liquid')) }
  let(:three_containers_reordered) { File.read(Smithy::Engine.root.join('spec', 'fixtures', 'templates', 'baz_foo_bar.html.liquid')) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:template) }
  it { should belong_to(:template) }
  it { should have_many(:pages).through(:template) }

  # containers are never managed directly - they are always
  # auto-created via the containers in the content of a template
  # therefore, we test the creation and destruction of containers
  # via the templates themselves
  # see Template#load_containers
  context "when the template is not a regular 'template'" do
    let(:template) { create(:template, :content => one_container, :template_type => "include") }
    subject { template.containers }
    its(:size) { should == 0 }
  end

  context "a template with a single container" do
    let(:template) { create(:template, :content => one_container) }
    subject { template.containers }
    its(:size) { should == 1 }
    context "the first container" do
      subject { template.containers.first }
      its(:name) { should == 'foo' }
    end
    context "increased to 3 containers" do
      before do
        template.update_attributes(:content => three_containers)
      end
      its(:size) { should == 3 }
    end
    context "reduced to 0 containers" do
      before do
        template.update_attributes(:content => '{{ no_containers }}')
      end
      its(:size) { should == 0 }
      specify { subject.map(&:name).should == [] }
    end
  end

  context "a template with a three containers" do
    let(:template) { create(:template, :content => three_containers) }
    subject { template.containers }
    before do
      template.reload # it wasn't showing the right results without this
    end
    its(:size) { should == 3 }
    specify { subject.map(&:position).should == [0, 1, 2] }
    specify { subject.map(&:name).should == %w(foo bar baz_qux) }
    specify { subject.map(&:display_name).should == ['Foo', 'Bar', 'Baz Qux'] }
    context "reduced to 1 containers" do
      before do
        template.update_attribute(:content, one_container)
      end
      its(:size) { should == 1 }
      specify { subject.map(&:name).should == %w(foo) }
    end
    context "reduced to 0 containers" do
      before do
        template.update_attribute(:content, '{{ no_containers }}')
      end
      its(:size) { should == 0 }
      specify { subject.map(&:name).should == [] }
    end
    context "with the containers reordered" do
      before do
        template.update_attribute(:content, three_containers_reordered)
        template.reload
      end
      specify { subject.map(&:position).should == [0, 1, 2] }
      specify { subject.map(&:name).should == %w(baz_qux foo bar) }
    end
  end
end
