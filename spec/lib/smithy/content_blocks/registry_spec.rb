require 'spec_helper'

class Smithy::Foo
  def self.table_name
    'smithy_foos'
  end
end
class Smithy::Bar
  def self.table_name
    'smithy_bars'
  end
end
class Smithy::Baz
  def self.table_name
    'smithy_bazs'
  end
end

describe Smithy::ContentBlocks::Registry do
  subject { Smithy::ContentBlocks::Registry.content_blocks }

  context "when the table exists" do
    before do
      ActiveRecord::Base.connection.stub(:table_exists?).and_return(true)
      Smithy::ContentBlocks::Registry.register(Smithy::Foo)
    end
    it "won't add a content block to the registry that already exists" do
      expect { Smithy::ContentBlocks::Registry.register(Smithy::Foo) }.to_not change{subject.size}
      expect { Smithy::ContentBlocks::Registry.register(Smithy::Foo) }.to_not change{Smithy::ContentBlock.count}
    end
    it "adds a content block to the registry" do
      expect { Smithy::ContentBlocks::Registry.register(Smithy::Bar) }.to change{subject.size}.by(1)
    end
    it "adds a content block to the DB" do
      expect { Smithy::ContentBlocks::Registry.register(Smithy::Baz) }.to change{Smithy::ContentBlock.count}.by(1)
    end
  end

  context "when the table doesn't exist" do
    before do
      ActiveRecord::Base.connection.stub(:table_exists?).and_return(false)
    end
    it "won't register the content block" do
      Smithy::ContentBlocks::Registry.register(Smithy::Foo)
      expect { Smithy::ContentBlocks::Registry.register(Smithy::Foo) }.to_not change{subject.size}
      expect { Smithy::ContentBlocks::Registry.register(Smithy::Foo) }.to_not change{Smithy::ContentBlock.count}
    end
  end
end
