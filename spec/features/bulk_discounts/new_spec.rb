require "rails_helper"

RSpec.describe "bulk discount new" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Jewelry Jar")
    @bulk_discount_1 = BulkDiscount.create!(name: "Fire Sale", percentage: 0.1, quantity: 10, merchant_id: @merchant1.id)
    @bulk_discount_2 = BulkDiscount.create!(name: "Going Out of Business", percentage: 0.25, quantity: 20, merchant_id: @merchant1.id)
    @bulk_discount_3 = BulkDiscount.create!(name: "Spring Fling", percentage: 0.30, quantity: 100, merchant_id: @merchant2.id)
  
    visit new_merchant_bulk_discount_path(@merchant1)
  end

  it "can add a new bulk discount" do
    expect(page).to have_content("New Bulk Discount")

    fill_in "Name", with: "New Discount"
    fill_in "percentage", with: ".15"
    fill_in "Quantity", with: "25"
    click_button "Submit"

    expect(page).to have_content("Bulk Discounts Index")
    
    within("#bulk-discount-item-#{BulkDiscount.last.id}") do
      expect(page).to have_content("New Discount")
      expect(page).to have_content("Percentage: 15%")
      expect(page).to have_content("Quantity: 25")
    end
  end
  
  it "can not build a new discount without all the fields filled in" do
    expect(page).to have_content("New Bulk Discount")

    fill_in "Name", with: "New Discount"
    fill_in "percentage", with: ".15"
    click_button "Submit"

    expect(page).to have_content("All fields must be completed, get your act together.")
  end
end
