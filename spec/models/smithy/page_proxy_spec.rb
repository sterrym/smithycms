require 'spec_helper'

describe Smithy::PageProxy, :focus => true do
  let(:page) { Smithy::PageProxy.new(:path => 'test', :title => "Foo Bar") }
  subject { page }

  [:id, :browser_title, :title, :path, :keywords, :description].each do |attribute|
    it "allows attributes (#{attribute}) to be set in instantiation" do
      page = Smithy::PageProxy.new(attribute => 'This is a test')
      page.send("#{attribute}".to_sym).should eql "This is a test"
    end
    it "allows attributes (#{attribute}) to be set" do
      page.send("#{attribute}=".to_sym, "This is a test")
      page.send("#{attribute}".to_sym).should eql "This is a test"
    end
  end

  describe "#id" do
    it "allows the id to be specified" do
      page.id = 'foo'
      page.id.should eql 'foo'
    end
    it "passes an MD5 hash of the path if id is not passed" do
      page.path = '/foo'
      page.id = nil
      page.id.should eql '1effb2475fcfba4f9e8b8a1dbc8f3caf'
    end
  end

  describe "#add_to_container" do
    subject { page.containers }
    before do
      page.add_to_container(:foo, 'Foo Content')
      page.add_to_container(:bar, 'Bar Content')
      page.add_to_container(:BAZ_CONTENT, 'BAZ Content')
    end
    specify { subject[:foo].should be_nil }
    specify { subject["foo"].should == 'Foo Content'}
    specify { subject["bar"].should == 'Bar Content'}
    specify { subject["BAZ_CONTENT"].should == 'BAZ Content'}
  end

  describe "#to_liquid" do
    subject { page.to_liquid }
    it { should be_a(Hash) }
    it { should have_key('title') }
    it { should have_key('browser_title') }
    it { should have_key('meta_description') }
    it { should have_key('meta_keywords') }
    it { should have_key('container') }
    describe "['container']" do
      before do
        page.add_to_container(:foo, 'Foo Content')
        page.add_to_container(:bar, 'Bar Content')
        page.add_to_container(:BAZ_CONTENT, 'BAZ Content')
      end
      subject { page.to_liquid['container'] }
      its(:keys) { should == ['foo', 'bar', 'BAZ_CONTENT'] }
    end
  end
end
