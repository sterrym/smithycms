module Smithy
  class Site

    def root
      @root ||= Smithy::Page.root
    end

    def to_liquid
      {
        'root' => self.root.to_liquid
      }
    end
  end
end
