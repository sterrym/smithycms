module Smithy
  module PagesHelper
    def tree_for_select
      tree_for_select = []
      Smithy::Page.each_with_level(Smithy::Page.root.self_and_descendants) do |page, level|
        prepend = level == 0 ? '' : "#{'-' * level} "
        tree_for_select << [ "#{prepend}#{page.title}", page.id]
      end if Smithy::Page.root.present?
      tree_for_select
    end
  end
end
