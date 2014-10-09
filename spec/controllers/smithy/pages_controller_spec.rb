require 'rails_helper'

RSpec.describe ApplicationController do
  let(:template_content) { File.read(Smithy::Engine.root.join('spec', 'fixtures', 'templates', 'foo_bar_baz.html.liquid')) }
  let!(:template) { Smithy::Template.create(:name => 'foo', :content => template_content) }

  describe "#render_as_smithy_page" do
    controller do
      include Smithy::Liquid::Rendering
      def index
        @page = Smithy::PageProxy.new(:id => 'test', :path => 'foo/bar')
        @page.add_to_container(:foo, "Test content 1")
        @page.add_to_container(:bar, "Test content 2")
        @page.add_to_container(:baz_qux, "Test content 3")
        @page.add_to_container(:baz_qux, "Test content 4")
        @page.add_to_container(:doesnt_exist, "Test content 5")
        render_as_smithy_page('foo')
      end
    end

    it "renders the smithy template" do
      get :index
      expect(response.body).to have_text("Test content 1")
      expect(response.body).to have_text("Test content 2")
      expect(response.body).to have_text("Test content 3")
      expect(response.body).to have_text("Test content 4")
      expect(response.body).to_not have_text("Test content 5")
    end
  end


end
