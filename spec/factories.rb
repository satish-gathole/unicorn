FactoryGirl.define do

  factory :user do
    username              "TestUser"
    email                 "testuser@example.com"
    password              "password"
    password_confirmation "password"
  end

end
