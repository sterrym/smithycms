require 'rails_helper'

RSpec.describe Smithy::Asset, :type => :model, :focus => true do
  let(:file) { Smithy::Engine.root.join('spec', 'fixtures', 'assets', 'treats-and_stuff.png') }
  let(:uploaded_file) { "http://s3.amazonaws.com/#{ENV['AWS_S3_BUCKET']}/test/treats-and_stuff.png" }
  before do
    base_path = "http://s3.amazonaws.com/"
    path = "^#{base_path}#{ENV['AWS_S3_BUCKET']}/([^/.]+/)*#{File.basename(file)}$"
    FakeWeb.register_uri(:put, Regexp.new(path), :body => "OK")
    FakeWeb.register_uri(:get, base_path, :body => File.read(Smithy::Engine.root.join('spec', 'fixtures', 'assets', 'aws_buckets.html')))
    FakeWeb.register_uri(:get, uploaded_file, :body => File.read(file))
  end

  context "validations" do
    specify {
      subject.save
      expect(subject.errors.messages[:file]).to_not be_blank
    }
    it { is_expected.to validate_presence_of(:name) }
  end

  context "when loading a file, the" do
    subject { create(:asset, :file => File.open(file)) }

    it { debugger }

    describe '#name' do
      subject { super().name }
      it { is_expected.to eql 'Treats And Stuff' }
    end

    describe '#file_content_type' do
      subject { super().file_content_type }
      it { is_expected.to eql 'image/png' }
    end

    describe '#file_type' do
      subject { super().file_type }
      it { is_expected.to eql :image }
    end

    describe '#file_filename' do
      subject { super().file_filename }
      it { is_expected.to eql 'treats-and_stuff.png' }
    end

    describe '#file_size' do
      subject { super().file_size }
      it { is_expected.to eql 28773 }
    end

    # describe '#file_height' do
    #   subject { super().file_height }
    #   it { is_expected.to eql 170 }
    # end

    # describe '#file_width' do
    #   subject { super().file_width }
    #   it { is_expected.to eql 153 }
    # end
  end

  # context "when only uploaded_file_url is populated (aka jquery_file_upload did it), the" do
  #   subject { create(:asset, :uploaded_file_url => uploaded_file) }

  #   describe '#name' do
  #     subject { super().name }
  #     it { is_expected.to eql 'Treats And Stuff' }
  #   end

  #   describe '#content_type' do
  #     subject { super().content_type }
  #     it { is_expected.to eql 'image' }
  #   end

  #   describe '#file_size' do
  #     subject { super().file_size }
  #     it { is_expected.to eql 28773 }
  #   end

  #   describe '#file_height' do
  #     subject { super().file_height }
  #     it { is_expected.to eql 170 }
  #   end

  #   describe '#file_width' do
  #     subject { super().file_width }
  #     it { is_expected.to eql 153 }
  #   end
  # end

  context "saving to local filesystem" do
  end

end
