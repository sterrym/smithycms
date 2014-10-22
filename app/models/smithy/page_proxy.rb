require 'digest/md5'
module Smithy
  class PageProxy
    # The PageProxy class is a way for a developer to use an already existing
    # template in their own controllers and views.
    # Simply instantiate the object and set the appropriate attributes.
    # You can even render your views in erb and pass the results along for the
    # Smithy template containers you've already created from within Smithy
    # Eg:
    # class ExamplesController < ApplicationController
    #   respond_to :html
    #   layout false
    #   include Smithy::Liquid::Rendering
    #   def index
    #     @page = Smithy::PageProxy.new(:path => request.path, :title => "Test")
    #     @page.add_to_container(:main_content, render_to_string(:action => 'index'))
    #     respond_with @page do |format|
    #       format.html { render_as_smithy_page('Default') }
    #     end
    #   end
    # end


    attr_accessor :id, :browser_title, :title, :path, :keywords, :description

    def initialize(attributes = {})
      @containers = {}
      [:id, :browser_title, :title, :path, :keywords, :description].each do |k|
        self.send("#{k}=".to_sym, attributes[k]) if attributes[k].present?
      end
    end

    def id
      @id ||= Digest::MD5.hexdigest(path)
    end

    def containers
      @containers
    end

    def add_to_container(container_name, content)
      @containers[container_name.to_s] ||= ''
      @containers[container_name.to_s] << content
      @containers
    end

    def site
      @site ||= Smithy::Site.instance
    end

    def to_liquid
      {
        'id' => self.id,
        'browser_title' => (self.browser_title.present? ? self.browser_title : self.title),
        'title' => title,
        'path' => path,
        'meta_description' => description,
        'meta_keywords' => keywords,
        'container' => containers
      }
    end
  end
end
