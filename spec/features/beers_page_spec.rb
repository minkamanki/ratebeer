require 'rails_helper'

include Helpers

describe "Beers" do
    let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
    let!(:user) { FactoryBot.create :user }

    before :each do
        sign_in(username: "Pekka", password: "Foobar1")
    end
    
    it "can be created" do
        visit new_beer_path
        fill_in('beer[name]', with: 'Test')
        select('Lager', from: 'beer[style]')
        select('Koff', from: 'beer[brewery_id]')
        
    
        expect{
          click_button "Create Beer"
        }.to change{Beer.count}.from(0).to(1)
    end

    it "need to have valid name" do
        visit new_beer_path
        fill_in('beer[name]', with: '')
        select('Lager', from: 'beer[style]')
        select('Koff', from: 'beer[brewery_id]')
        click_button "Create Beer"
        expect(Beer.count).to eq(0)
    end
end