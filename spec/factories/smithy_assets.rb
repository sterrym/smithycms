# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :asset, :class => 'Smithy::Asset' do
    file { File.open Smithy::Engine.root.join('spec', 'fixtures', 'assets', 'treats-and_stuff.png') }
  end
end
