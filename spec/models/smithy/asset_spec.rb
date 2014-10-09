require 'rails_helper'

RSpec.describe Smithy::Asset, :type => :model do
  let(:file) { Smithy::Engine.root.join('spec', 'fixtures', 'assets', 'treats-and_stuff.png') }
  let(:uploaded_file) { "http://s3.amazonaws.com/#{ENV['AWS_S3_BUCKET']}/test/treats-and_stuff.png" }
  before do
    base_path = "http://s3.amazonaws.com/"
    path = "^#{base_path}#{ENV['AWS_S3_BUCKET']}/([^/.]+/)*#{File.basename(file)}$"
    FakeWeb.register_uri(:put, Regexp.new(path), :body => "OK")
    FakeWeb.register_uri(:get, base_path, :body => File.read(Smithy::Engine.root.join('spec', 'fixtures', 'assets', 'aws_buckets.html')))
    FakeWeb.register_uri(:get, uploaded_file, :body => File.read(file))
  end

  it { is_expected.to validate_presence_of(:file) }
  it { is_expected.to validate_presence_of(:name) }

  context "when loading a file, the" do
    subject { create(:asset, :file => file) }

    describe '#name' do
      subject { super().name }
      it { is_expected.to eql 'Treats And Stuff' }
    end

    describe '#content_type' do
      subject { super().content_type }
      it { is_expected.to eql 'image' }
    end

    describe '#file_name' do
      subject { super().file_name }
      it { is_expected.to eql 'treats-and_stuff.png' }
    end

    describe '#file_size' do
      subject { super().file_size }
      it { is_expected.to eql 28773 }
    end

    describe '#file_height' do
      subject { super().file_height }
      it { is_expected.to eql 170 }
    end

    describe '#file_width' do
      subject { super().file_width }
      it { is_expected.to eql 153 }
    end
  end

  context "when only uploaded_file_url is populated, the" do
    subject { create(:asset, :uploaded_file_url => uploaded_file) }

    describe '#name' do
      subject { super().name }
      it { is_expected.to eql 'Treats And Stuff' }
    end

    describe '#content_type' do
      subject { super().content_type }
      it { is_expected.to eql 'image' }
    end

    describe '#file_size' do
      subject { super().file_size }
      it { is_expected.to eql 28773 }
    end

    describe '#file_height' do
      subject { super().file_height }
      it { is_expected.to eql 170 }
    end

    describe '#file_width' do
      subject { super().file_width }
      it { is_expected.to eql 153 }
    end
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
