require 'formtastic-bootstrap/inputs/text_input'
class MarkdownInput < FormtasticBootstrap::Inputs::TextInput
  def to_html
    self.options[:hint] = markdown_hint if self.options[:hint].blank?
    bootstrap_wrapping do
      builder.text_area(method, form_control_input_html_options) +
      builder.template.content_tag(:div, nil, id: editor_id, class: 'ace_editor', data: { id: id, type: :markdown, name: dom_id, assets_url: builder.template.selector_modal_assets_path, pages_url: builder.template.selector_modal_pages_path }) +
      builder.template.content_tag(:div, nil, id: 'content-guide')
    end
  end

  def id
    builder.object.id || 'new'
  end

  def textarea_id
    "#{dom_id}-#{id}"
  end

  def editor_id
    "#{dom_id}_editor-#{id}"
  end

  def input_html_options
    {
      class: "col-md-12",
    }.merge(super).merge(id: textarea_id)
  end

  def markdown_hint
    "Use markdown syntax for formatting. You can also use HTML directly. <a href=\"#{builder.template.guide_path('markdown')}\" data-toggle=\"remote-load\" data-target=\"#content-guide\">See our markdown syntax reference</a>".html_safe
  end
end
