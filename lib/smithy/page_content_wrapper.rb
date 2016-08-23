module Smithy
  class PageContentWrapper
    attr_reader :page_content
    include ActionView::Helpers::TagHelper

    def initialize(page_content)
      @page_content = page_content
    end

    def wrap(output)
      return output if !page_content.persisted?
      content_tag(:div, output.html_safe, id: "page_content_#{page_content.id}", class: page_content.css_classes)
    end
  end
end
