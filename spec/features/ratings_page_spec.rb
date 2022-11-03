require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }
  let!(:user2) { FactoryBot.create :user, username: "Test" }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
    
    visit ratings_path
    expect(page).to have_content 'Number of ratings: 1'
    expect(page).to have_content 'iso 3: 15 -- from user Pekka'
  end

  it "shows own ratings in own page" do
    create_beers_with_many_ratings({user: user2}, 10, 20, 15, 7, 9)
    create_beer_with_rating({user: user}, 44)
    visit user_path(user)
    expect(page).to have_content 'TestBeer: 44 Delete'
    expect(page).to have_no_content 'TestBeer: 9 Delete'
  end

  it "don't show deleted ratings" do
    create_beer_with_rating({user: user}, 44)
    visit user_path(user)
    expect(page).to have_content 'TestBeer: 44 Delete'
    click_button "Delete"
    expect(page).to have_no_content 'TestBeer: 44 Delete'
  end
end