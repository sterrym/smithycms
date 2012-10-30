# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :page_content, :class => 'Smithy::PageContent' do
    page
    container 'main_content'
    label { Faker::Lorem.words(2).join(' ') }
  end
end
