require 'rails_helper'

RSpec.describe Smithy::Formatter do
  subject(:content) { Faker::Lorem.sentence }
  subject(:formatter) { formatter = Smithy::Formatter.new(content) }

  describe "#render" do
    subject(:render) { formatter.render.gsub(/\n/, '') }
    it { is_expected.to eql "<p>#{content}</p>" }
    %w( p div ul ol li blockquote pre h1 h2 h3 h4 h5 h6 object ).each do |tag|
      context "block-level tags" do
        subject(:content) { "<#{tag}>#{Faker::Lorem.sentence}</#{tag}>"}
        it "(#{tag}) shouldn't be removed" do
          expect(render).to eql content
        end
      end
    end
    %w( hr param ).each do |tag|
      context "self-closing block-level tags" do
        subject(:content) { "<#{tag}>foo bar baz"}
        it "(#{tag}) shouldn't be removed" do
          expect(render).to eql "<#{tag}><p>foo bar baz</p>"
        end
      end
    end
    %w( a span sub sup strong em abbr code del small big ).each do |tag|
      context "span-level tags" do
        subject(:content) { "<#{tag}>#{Faker::Lorem.sentence}</#{tag}>"}
        it "(#{tag}) shouldn't be removed" do
          expect(render).to eql "<p>#{content}</p>"
        end
      end
    end
    %w( br img ).each do |tag|
      context "inline tags" do
        subject(:content) { "#{Faker::Lorem.sentence} <#{tag}>"}
        it "(#{tag}) shouldn't be removed" do
          expect(render).to eql "<p>#{content}</p>"
        end
      end
    end
  end
end
