module Smithy
  class Site
    cattr_accessor :title

    class << self
      def title
        @@title
      end

      def title=(str)
        @@title = str
      end
    end

    def title
      self.class.title
    end

    def root
      @root ||= Smithy::Page.root
    end

    def to_liquid
      {
        'title' => self.title,
        'root' => self.root.to_liquid
      }
    end
  end
end
