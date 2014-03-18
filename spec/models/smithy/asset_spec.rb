require 'spec_helper'

describe Smithy::Asset do
  let(:file) { Smithy::Engine.root.join('spec', 'fixtures', 'assets', 'treats-and_stuff.png') }
  let(:uploaded_file) { "http://s3.amazonaws.com/#{ENV['AWS_S3_BUCKET']}/test/treats-and_stuff.png" }
  before do
    base_path = "http://s3.amazonaws.com/"
    path = "^#{base_path}#{ENV['AWS_S3_BUCKET']}/([^/.]+/)*#{File.basename(file)}$"
    FakeWeb.register_uri(:put, Regexp.new(path), :body => "OK")
    FakeWeb.register_uri(:get, base_path, :body => File.read(Smithy::Engine.root.join('spec', 'fixtures', 'assets', 'aws_buckets.html')))
    FakeWeb.register_uri(:get, uploaded_file, :body => File.read(file))
  end

  it { should validate_presence_of(:file) }
  it { should validate_presence_of(:name) }

  context "when loading a file, the" do
    subject { create(:asset, :file => file) }
    its(:name) { should eql 'Treats And Stuff' }
    its(:content_type) { should eql 'image' }
    its(:file_name) { should eql 'treats-and_stuff.png' }
    its(:file_size) { should eql 28773 }
    its(:file_height) { should eql 170 }
    its(:file_width) { should eql 153 }
  end

  context "when only uploaded_file_url is populated, the" do
    subject { create(:asset, :uploaded_file_url => uploaded_file) }
    its(:name) { should eql 'Treats And Stuff' }
    its(:content_type) { should eql 'image' }
    its(:file_size) { should eql 28773 }
    its(:file_height) { should eql 170 }
    its(:file_width) { should eql 153 }
  end

  context "using the FileDataStore" do
    before do
      %w(AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_S3_BUCKET).each{|k| ENV[k] = nil }
      Dragonfly.app.configure do
        datastore Smithy::Asset.dragonfly_datastore
      end
    end
    it "saves with a file" do
      create(:asset, :file => file)
    end
    it "saves with an uploaded_file_url" do
      create(:asset, :uploaded_file_url => uploaded_file)
    end
  end

end
