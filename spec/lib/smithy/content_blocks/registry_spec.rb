require 'spec_helper'

describe Smithy::ContentBlocks::Registry do
  before do
    Smithy::ContentBlocks::Registry.register("Foo")
  end
  subject { Smithy::ContentBlocks::Registry.content_blocks }

  it "won't add a content block to the registry that already exists" do
    expect { Smithy::ContentBlocks::Registry.register("Foo") }.to_not change{subject.size}
    expect { Smithy::ContentBlocks::Registry.register("Foo") }.to_not change{Smithy::ContentBlock.count}
  end
  it "adds a content block to the registry" do
    expect { Smithy::ContentBlocks::Registry.register("Bar") }.to change{subject.size}.by(1)
  end
  it "adds a content block to the DB" do
    expect { Smithy::ContentBlocks::Registry.register("Baz") }.to change{Smithy::ContentBlock.count}.by(1)
  end
end
