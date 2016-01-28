class LookForDirectAssetLinks < ActiveRecord::Migration
  def change
    Smithy::Content.where("content LIKE '%s3.amazonaws.com%' OR content LIKE '%/uploads/assets/%'").each do |content|
      content.page_contents.each do |page_content|
        say "[WARNING] Direct Link found in the Page: #{page_content.page.title} - #{page_content.page.url}"
        say "Content Block(s): #{page_content.label}", true
        say content.content.scan(/(?:[^\s]*s3\.amazonaws\.com|\/uploads\/assets)[^\s]*/).join('/n'), true
        say "You can find the new asset url on the smithy/assets page", true
      end
    end
  end
end

