# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :page_content, :class => 'Smithy::PageContent' do
    page
    container 'main_content'
    label { FFaker::Lorem.words(2).join(' ') }
    association :content_block, factory: :content
    association :content_block_template
    trait :publishable do
      publishable true
    end
  end
end
