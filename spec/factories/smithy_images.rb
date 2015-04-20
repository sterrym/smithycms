# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :image, :class => 'Smithy::Image' do
    asset
    alternate_text { FFaker::Lorem.words(5).join(' ') }
    content { FFaker::Lorem.sentence }
  end
end
