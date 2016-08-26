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
  let(:extra_nested_attribtues) { [:id, :_destroy] }

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
    it_should_behave_like "returning permitted_params" do
     let(:param_name) { "page" }
      let(:allowed_attributes) { page_attributes << { contents_attributes: page_content_attributes + extra_nested_attribtues } }
    end
  end
  describe "page_content attributes" do
    it_should_behave_like "returning permitted_params" do
      let(:param_name) { "page_content" }
      let(:allowed_attributes) { page_content_attributes }
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
    ActionController::Parameters.new(attributes_for(model))
  end
end
