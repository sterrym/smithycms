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

  {
    asset: [ :name, :file, :file_name, :file_url, :retained_file, :uploaded_file_url ],
    content: [ :content ],
    content_block: :all,
    content_block_template:  [ :content, :name ],
    image: [ :alternate_text, :asset_id, :height, :html_attributes, :image_scaling, :link_url, :width, :content ],
    page:  [ :browser_title, :cache_length, :description, :external_link, :keywords, :permalink, :publish, :published_at, :show_in_navigation, :title, :parent_id, :template_id, :copy_content_from],
    page_content: :all,
    page_list: [ :count, :page_template_id, :parent_id, :include_children, :sort ],
    setting: [ :name, :value ],
    template:  [ :name, :content, :template_type ],
    template_container:  [ :name, :position ]
  }.each do |param_name, columns|
    context "for #{param_name}" do
      let(:param) { param_name.to_sym }
      let(:attributes) { fetch_attributes param }
      let(:params) { ActionController::Parameters.new( param => attributes ) }
      describe "##{param_name}_attributes" do
        subject { permitted_params.send("#{param_name}_attributes") }
        it { is_expected.to eq(columns) }
      end
      describe "#params_for(:#{param_name})" do
        subject { permitted_params.params_for(param) }
        it { is_expected.to eq(attributes) }
      end
    end
  end

  def fetch_attributes(model)
    ActionController::Parameters.new(attributes_for(model))
  end
end
