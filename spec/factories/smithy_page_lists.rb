# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :page_list, :class => 'Smithy::PageList' do
    sort 'sitemap'
  end
end
