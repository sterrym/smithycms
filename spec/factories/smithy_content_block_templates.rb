# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :content_block_template, :class => 'Smithy::ContentBlockTemplate' do
    content_block
    name { Faker::Lorem.words(5).join(' ') }
    content { Faker::Lorem.paragraph }
  end
end
