require 'spec_helper'

describe Smithy::PageProxy, :type => :model do
  let(:page) { Smithy::PageProxy.new(:path => 'test', :title => "Foo Bar") }
  subject { page }

  [:id, :browser_title, :title, :path, :keywords, :description].each do |attribute|
    it "allows attributes (#{attribute}) to be set in instantiation" do
      page = Smithy::PageProxy.new(attribute => 'This is a test')
      expect(page.send("#{attribute}".to_sym)).to eql "This is a test"
    end
    it "allows attributes (#{attribute}) to be set" do
      page.send("#{attribute}=".to_sym, "This is a test")
      expect(page.send("#{attribute}".to_sym)).to eql "This is a test"
    end
  end

  describe "#id" do
    it "allows the id to be specified" do
      page.id = 'foo'
      expect(page.id).to eql 'foo'
    end
    it "passes an MD5 hash of the path if id is not passed" do
      page.path = '/foo'
      page.id = nil
      expect(page.id).to eql '1effb2475fcfba4f9e8b8a1dbc8f3caf'
    end
  end

  describe "#add_to_container" do
    subject { page.containers }
    before do
      page.add_to_container(:foo, 'Foo Content')
      page.add_to_container(:bar, 'Bar Content')
      page.add_to_container(:BAZ_CONTENT, 'BAZ Content')
    end
    specify { expect(subject[:foo]).to be_nil }
    specify { expect(subject["foo"]).to eq('Foo Content')}
    specify { expect(subject["bar"]).to eq('Bar Content')}
    specify { expect(subject["BAZ_CONTENT"]).to eq('BAZ Content')}
  end

  describe "#to_liquid" do
    subject { page.to_liquid }
    it { is_expected.to be_a(Hash) }
    it { is_expected.to have_key('title') }
    it { is_expected.to have_key('browser_title') }
    it { is_expected.to have_key('meta_description') }
    it { is_expected.to have_key('meta_keywords') }
    it { is_expected.to have_key('container') }
    describe "['container']" do
      before do
        page.add_to_container(:foo, 'Foo Content')
        page.add_to_container(:bar, 'Bar Content')
        page.add_to_container(:BAZ_CONTENT, 'BAZ Content')
      end
      subject { page.to_liquid['container'] }

      describe '#keys' do
        subject { super().keys }
        it { is_expected.to eq(['foo', 'bar', 'BAZ_CONTENT']) }
      end
    end
  end
end
