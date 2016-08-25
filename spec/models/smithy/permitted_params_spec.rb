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

  shared_examples "specific permitted_params" do |param_name, allowed_attributes|
    let(:param_name) { param_name }
    let(:allowed_attributes) { allowed_attributes }
    let(:param) { param_name.to_sym }
    let(:attributes) { fetch_attributes param }
    describe "##{param_name}_attributes" do
      subject { permitted_params.send("#{param_name}_attributes") }
      it { is_expected.to eq(allowed_attributes) }
    end
    describe "#params_for(:#{param_name})" do
      subject { permitted_params.params_for(param) }
      it { is_expected.to eq(attributes) }
    end
    def fetch_attributes(model)
      ActionController::Parameters.new(attributes_for(model))
    end
  end

  describe "asset" do
    it_should_behave_like "specific permitted_params", "asset", [ :name, :file, :file_name, :file_url, :retained_file, :uploaded_file_url ]
  end
  describe "content" do
    it_should_behave_like "specific permitted_params", "content", [ :content ]
  end
  describe "content_block" do
    it_should_behave_like "specific permitted_params", "content_block", [:name, {:templates_attributes=>[:id, :name, :content, :_destroy]}]
  end
  # describe "content_block_template" do
  #   it_should_behave_like "specific permitted_params", "content_block_template",  [ :name, :content  ]
  # end
  # describe "image" do
  #   it_should_behave_like "specific permitted_params", "image", [ :alternate_text, :asset_id, :height, :html_attributes, :image_scaling, :link_url, :width, :content ]
  # end
  # describe "page" do
  #   it_should_behave_like "specific permitted_params", "page", [ :browser_title, :cache_length, :description, :external_link, :keywords, :permalink, :publish, :published_at, :show_in_navigation, :title, :parent_id, :template_id, :copy_content_from]
  # end
  # describe "page_content" do
  #   it_should_behave_like "specific permitted_params", "page_content", :all
  # end
  # describe "page_list" do
  #   it_should_behave_like "specific permitted_params", "page_list", [ :count, :page_template_id, :parent_id, :include_children, :sort ]
  # end
  # describe "setting" do
  #   it_should_behave_like "specific permitted_params", "setting", [ :name, :value ]
  # end
  # describe "template" do
  #   it_should_behave_like "specific permitted_params", "template",  [ :name, :content, :template_type ]
  # end
  # describe "template_container" do
  #   it_should_behave_like "specific permitted_params", "template_container", [ :name, :position ]
  # end

end
