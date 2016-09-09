# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :asset, :class => 'Smithy::Asset' do
    name { FFaker::Lorem.words(2).join(' ') }
    file { File.open Smithy::Engine.root.join('spec', 'fixtures', 'assets', 'treats-and_stuff.png') }
  end
end
