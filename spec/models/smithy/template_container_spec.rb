require 'spec_helper'

describe Smithy::TemplateContainer, :type => :model do
  let(:one_container) { File.read(Smithy::Engine.root.join('spec', 'fixtures', 'templates', 'foo.html.liquid')) }
  let(:three_containers) { File.read(Smithy::Engine.root.join('spec', 'fixtures', 'templates', 'foo_bar_baz.html.liquid')) }
  let(:three_containers_reordered) { File.read(Smithy::Engine.root.join('spec', 'fixtures', 'templates', 'baz_foo_bar.html.liquid')) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:template) }
  it { is_expected.to belong_to(:template) }
  it { is_expected.to have_many(:pages).through(:template) }

  # containers are never managed directly - they are always
  # auto-created via the containers in the content of a template
  # therefore, we test the creation and destruction of containers
  # via the templates themselves
  # see Template#load_containers
  context "when the template is not a regular 'template'" do
    let(:template) { create(:template, :content => one_container, :template_type => "include") }
    subject { template.containers }

    describe '#size' do
      subject { super().size }
      it { is_expected.to eq(0) }
    end
  end

  context "a template with a single container" do
    let(:template) { create(:template, :content => one_container) }
    subject { template.containers }

    describe '#size' do
      subject { super().size }
      it { is_expected.to eq(1) }
    end
    context "the first container" do
      subject { template.containers.first }

      describe '#name' do
        subject { super().name }
        it { is_expected.to eq('foo') }
      end
    end
    context "increased to 3 containers" do
      before do
        template.update_attributes(:content => three_containers)
      end

      describe '#size' do
        subject { super().size }
        it { is_expected.to eq(3) }
      end
    end
    context "reduced to 0 containers" do
      before do
        template.update_attributes(:content => '{{ no_containers }}')
      end

      describe '#size' do
        subject { super().size }
        it { is_expected.to eq(0) }
      end
      specify { expect(subject.map(&:name)).to eq([]) }
    end
  end

  context "a template with a three containers" do
    let(:template) { create(:template, :content => three_containers) }
    subject { template.containers }
    before do
      template.reload # it wasn't showing the right results without this
    end

    describe '#size' do
      subject { super().size }
      it { is_expected.to eq(3) }
    end
    specify { expect(subject.map(&:position)).to eq([0, 1, 2]) }
    specify { expect(subject.map(&:name)).to eq(%w(foo bar baz_qux)) }
    specify { expect(subject.map(&:display_name)).to eq(['Foo', 'Bar', 'Baz Qux']) }
    context "reduced to 1 containers" do
      before do
        template.update_attribute(:content, one_container)
      end

      describe '#size' do
        subject { super().size }
        it { is_expected.to eq(1) }
      end
      specify { expect(subject.map(&:name)).to eq(%w(foo)) }
    end
    context "reduced to 0 containers" do
      before do
        template.update_attribute(:content, '{{ no_containers }}')
      end

      describe '#size' do
        subject { super().size }
        it { is_expected.to eq(0) }
      end
      specify { expect(subject.map(&:name)).to eq([]) }
    end
    context "with the containers reordered" do
      before do
        template.update_attribute(:content, three_containers_reordered)
        template.reload
      end
      specify { expect(subject.map(&:position)).to eq([0, 1, 2]) }
      specify { expect(subject.map(&:name)).to eq(%w(baz_qux foo bar)) }
    end
  end
end
