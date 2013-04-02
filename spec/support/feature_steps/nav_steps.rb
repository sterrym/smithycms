module NavSteps
  def default_site_nav
    "{% nav 'site' %}"
  end

  def default_page_nav
    "{% nav 'page' %}"
  end

  def site_nav_with_depth_of_2
    "{% nav 'site', depth: 2 %}"
  end

  def site_nav_with_depth_of_0
    "{% nav 'site', depth: 0 %}"
  end

  def set_nav_to(template)
    Smithy::Page.all.each{|p| p.template.update_attributes(:content => template) }
  end

  def render_page(page)
    context = ::Liquid::Context.new({}, {}, { :page => page, :site => Smithy::Site.new }, false)
    page.template.liquid_template.render(context)
  end
end
