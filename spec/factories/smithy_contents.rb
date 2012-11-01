# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :content, :class => 'Smithy::Content' do
    content { Faker::Lorem.paragraph }
  end
end
