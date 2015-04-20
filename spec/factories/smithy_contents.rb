# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :content, :class => 'Smithy::Content' do
    content { FFaker::Lorem.paragraph }
  end
end
