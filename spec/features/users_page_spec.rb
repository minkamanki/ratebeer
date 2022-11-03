require 'rails_helper'

include Helpers

describe "User" do
    let!(:user) { FactoryBot.create :user }

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Wrong username and/or password'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with: 'Brian')
    fill_in('user_password', with: 'Secret55')
    fill_in('user_password_confirmation', with: 'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  it "show favorite brewery, beer and style" do
    create_beer_with_rating({user: user}, 44)
    visit user_path(user)
    expect(page).to have_content 'Favorite beer: TestBeer: TestBrewery'
    expect(page).to have_content 'Favorite beer style: Lager'
    expect(page).to have_content 'Favorite brewery: TestBrewery'
    end

end