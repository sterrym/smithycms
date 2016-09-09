require 'rails_helper'

RSpec.describe Smithy::PermittedParams, :type => :model do
  let(:user) { stub_const("User", double(:email => "test@example.com", :smithy_admin? => true)) }
  let(:params) { ActionController::Parameters.new(page: { bar: true, baz: "qux", corge: "not allowed" }) }
  let(:permitted_params) { Smithy::PermittedParams.new(params, user) }

  it "filters parameters" do
    expect(permitted_params).to receive(:page_attributes) { [:bar, :baz] }
    expect(permitted_params.params_for(:page)).to eq({ :bar => true, :baz => "qux" }.with_indifferent_access)
  end

  it "can allow all parameters" do
    expect(permitted_params).to receive(:page_attributes) { :all }
    expect(permitted_params.params_for(:page)).to eq(params[:page].with_indifferent_access)
  end

  shared_examples "returning permitted_params" do
    let(:allowed_attributes) { { foo: :bar } }
    let(:attributes) { fetch_attributes param }
    let(:param_name) { "foo" }
    let(:param) { param_name.to_sym }
    let(:params) { ActionController::Parameters.new( param => attributes ) }
    describe "allowed attributes" do
      subject { permitted_params.send("#{param_name}_attributes") }
      it { is_expected.to eq(allowed_attributes) }
    end
    describe "#params_for" do
      subject { permitted_params.params_for(param) }
      it { is_expected.to eq(attributes) }
    end
  end

  let(:asset_attributes) { [ :name, :file, :file_name, :file_url, :retained_file, :uploaded_file_url ] }
  let(:content_attributes) { [ :content ] }
  let(:content_block_attributes) { [:name, {:templates_attributes=>[:id, :name, :content, :_destroy]}] }
  let(:content_block_template_attributes) { [ :name, :content  ] }
  let(:image_attributes) { [ :alternate_text, :asset_id, :height, :html_attributes, :image_scaling, :link_url, :width, :content ] }
  let(:page_attributes) { [ :browser_title, :cache_length, :description, :external_link, :keywords, :permalink, :publish, :published_at, :show_in_navigation, :title, :parent_id, :template_id, :copy_content_from] }
  let(:page_content_attributes) { [ :label, :css_classes, :container, :content_block_type, :content_block_template_id, :position ] }
  let(:page_list_attributes) { [ :count, :page_template_id, :parent_id, :include_children, :sort ] }
  let(:setting_attributes) { [ :name, :value ] }
  let(:template_attributes) { [ :name, :content, :template_type ] }
  let(:template_container_attributes) { [ :name, :position ] }
  let(:extra_nested_attributes) { [:_destroy] }

  describe "asset attributes" do
    it_should_behave_like "returning permitted_params" do
      let(:param_name) { "asset" }
      let(:allowed_attributes) { asset_attributes }
    end
  end
  describe "content attributes" do
    it_should_behave_like "returning permitted_params" do
      let(:param_name) { "content" }
      let(:allowed_attributes) { content_attributes }
    end
  end
  describe "content_block attributes" do
    it_should_behave_like "returning permitted_params" do
      let(:param_name) { "content_block" }
      let(:allowed_attributes) { content_block_attributes }
    end
  end
  describe "content_block_template attributes" do
    it_should_behave_like "returning permitted_params" do
      let(:param_name) { "content_block_template" }
      let(:allowed_attributes) { content_block_template_attributes }
    end
  end
  describe "image attributes" do
    it_should_behave_like "returning permitted_params" do
      let(:param_name) { "image" }
      let(:allowed_attributes) { image_attributes }
    end
  end
  describe "page attributes" do
    # page allowed_attributes need to include all of the content_attributes, including the nested content_block_attributes
    it_should_behave_like "returning permitted_params" do
      let(:param_name) { "page" }
      let(:allowed_attributes) do
        contents_attributes = page_content_attributes
        content_block_attributes = content_attributes + image_attributes + page_list_attributes + [:id, :_destroy]
        contents_attributes << { content_block_attributes: content_block_attributes }
        contents_attributes += [:id, :_destroy]
        page_attributes << { contents_attributes: contents_attributes }
      end
    end
  end
  # page_content allowed_attributes need to include all of the nested content_block_attributes
  describe "page_content attributes" do
    it_should_behave_like "returning permitted_params" do
      let(:param_name) { "page_content" }
      let(:allowed_attributes) do
        allowed_attributes = page_content_attributes
        # the default content blocks pieces
        content_block_attributes = content_attributes + image_attributes + page_list_attributes + [:id, :_destroy]
        allowed_attributes << {content_block_attributes: content_block_attributes }
        allowed_attributes
      end
    end
    context "with #content_block_type" do
      it_should_behave_like "returning permitted_params" do
        let(:param_name) { "page_content" }
        let(:attributes) do
          attributes = FactoryGirl.build(param, page: Smithy::Page.first).attributes.select{|k, v| page_content_attributes.include?(k.to_sym) }
          attributes[:content_block_attributes] = FactoryGirl.build(:content).attributes.select{|k,v| (content_attributes + extra_nested_attributes + [:id]).include?(k.to_sym) }
          ActionController::Parameters.new(attributes)
        end
        let(:allowed_attributes) do
          allowed_attributes = page_content_attributes
          # the default content blocks pieces
          content_block_attributes = content_attributes + image_attributes + page_list_attributes + [:id, :_destroy]
          allowed_attributes << {content_block_attributes: content_block_attributes }
          allowed_attributes
        end
      end
    end
  end
  describe "page_list attributes" do
    it_should_behave_like "returning permitted_params" do
      let(:param_name) { "page_list" }
      let(:allowed_attributes) { page_list_attributes }
    end
  end
  describe "setting attributes" do
    it_should_behave_like "returning permitted_params" do
      let(:param_name) { "setting" }
      let(:allowed_attributes) { setting_attributes }
    end
  end
  describe "template attributes" do
    it_should_behave_like "returning permitted_params" do
      let(:param_name) { "template" }
      let(:allowed_attributes) { template_attributes }
    end
  end
  describe "template_container attributes" do
    it_should_behave_like "returning permitted_params" do
      let(:param_name) { "template_container" }
      let(:allowed_attributes) { template_container_attributes }
    end
  end

  def fetch_attributes(model)
    ActionController::Parameters.new(FactoryGirl.build(model))
  end
end
