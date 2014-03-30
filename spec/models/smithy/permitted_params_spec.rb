require 'spec_helper'

describe Smithy::PermittedParams do
  let(:user) { stub_const("User", double(:email => "test@example.com", :smithy_admin? => true)) }
  let(:params) { ActionController::Parameters.new(foo: { bar: true, baz: "qux", corge: "not allowed" }) }
  let(:permitted_params) { Smithy::PermittedParams.new(params, user) }

  it "filters parameters" do
    allow(permitted_params).to receive(:foo_attributes) { [:bar, :baz] }
    filtered_params = permitted_params.params_for(:foo)
    expect(filtered_params).to eq({ :bar => true, :baz => "qux" }.with_indifferent_access)
  end

  it "can allow all parameters" do
    allow(permitted_params).to receive(:foo_attributes) { :all }
    filtered_params = permitted_params.params_for(:foo)
    expect(filtered_params).to eq(params[:foo].with_indifferent_access)
  end

  {
    asset: [ :name, :file, :file_name, :file_url, :retained_file, :uploaded_file_url ],
    content: [ :content ],
    # content_block: [ :name, templates_attributes: [:id, :name, :content, :_destroy] ],
    content_block: :all,
    content_block_template:  [ :content, :name ],
    image: [ :alternate_text, :asset_id, :height, :html_attributes, :image_scaling, :link_url, :width, :content ],
    page:  [ :browser_title, :cache_length, :description, :external_link, :keywords, :permalink, :publish, :published_at, :show_in_navigation, :title, :parent_id, :template_id ],
    # page_content:  [ :label, :container, :content_block_type, :content_block_template_id, :position ],
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
        it { should == columns }
      end
      describe "#params_for(:#{param_name})" do
        subject { permitted_params.params_for(param) }
        it { should == attributes }
      end
    end
  end

  def fetch_attributes(model)
    ActionController::Parameters.new(attributes_for(model))
  end
end
