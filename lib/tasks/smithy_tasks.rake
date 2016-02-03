require 'smithycms'
require 'smithy/content'
require 'smithy/template'
namespace :smithy do
  desc "Track down any usage of linking directly to Smithy Assets. Use /smithy/assets/1 instead"
  task :find_direct_asset_links do
    Smithy::Template.where('content LIKE ? OR content LIKE ?', '%s3.amazonaws.com%', '%/uploads/assets/%').each do |template|
      puts "[WARNING] Direct Link found in the Template: #{template.name}"
      find_and_print_matches(template.content)
    end

    Smithy::Content.where('content LIKE ? OR content LIKE ?', '%s3.amazonaws.com%', '%/uploads/assets/%').each do |content|
      content.page_contents.each do |page_content|
        puts "[WARNING] Direct Link found in the Page: #{page_content.page.title} - #{page_content.page.url}"
        puts "  Content Block(s): #{page_content.label}"
        find_and_print_matches(content.content)
      end
    end
  end

  def find_and_print_matches(content)
    asset_regex = /(?:https?:\/\/.*s3\.amazonaws\.com|\/uploads\/assets)[a-z0-9\/\._-]+/i
    content.scan(asset_regex) do |match|
      puts "  #{match}\n"
      if Smithy::Asset.where("file_name LIKE ?", "%#{File.basename(match)}%").size > 0
        puts "    Possible Match(es):"
        Smithy::Asset.where("file_name LIKE ?", "%#{File.basename(match)}%").map{|a| "/smithy/assets/#{a.id}"}.each do |link|
          puts "    #{link}"
        end
      end
    end
    puts "\n"
  end

end
