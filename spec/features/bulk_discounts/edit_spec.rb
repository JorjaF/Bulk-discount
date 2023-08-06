require "rails_helper"

RSpec.describe "bulk discount edit", type: :feature do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Jewelry Jar")
    @bulk_discount_1 = BulkDiscount.create!(name: "Fire Sale", percentage: 0.1, quantity: 10, merchant_id: @merchant1.id)
    @bulk_discount_2 = BulkDiscount.create!(name: "Going Out of Business", percentage: 0.25, quantity: 20, merchant_id: @merchant1.id)
    @bulk_discount_3 = BulkDiscount.create!(name: "Spring Fling", percentage: 0.30, quantity: 100, merchant_id: @merchant2.id)
  end

  it "sees a form filled in with the bulk discounts current info" do
    visit edit_merchant_bulk_discount_path(@merchant1, @bulk_discount_1)

    expect(page).to have_field("Name", with: @bulk_discount_1.name)
    expect(page).to have_field("bulk_discount[percentage]", with: @bulk_discount_1.percentage)
    expect(page).to have_field("Quantity", with: @bulk_discount_1.quantity)

    expect(find_field("Name").value).to_not eq(@bulk_discount_2.name)
  end

  it "can fill in form, click submit, and redirect to that bulk discount's show page and see updated info and flash message" do
    visit edit_merchant_bulk_discount_path(@merchant1, @bulk_discount_1)
    
    fill_in "Name", with: "Hair Flair"
    fill_in "bulk_discount[percentage]", with: ".25"
    fill_in "Quantity", with: "15"
    
    click_button "Submit"

    expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @bulk_discount_1))
    expect(page).to have_content("Hair Flair")
    expect(page).to have_content("25%")
    expect(page).to have_content("15")
    expect(page).to_not have_content("Fire Sale")
    expect(page).to have_content("Succesfully Updated Bulk Discount Info!")
  end

  it "can fill in form, click submit, and redirect to that bulk discount's show page and see updated info and flash message" do
    visit edit_merchant_bulk_discount_path(@merchant1, @bulk_discount_1)
    
    fill_in "Name", with: "Hair Flair"
    fill_in "bulk_discount[percentage]", with: ".25"
    fill_in "Quantity", with: ""
    
    click_button "Submit"

    expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @bulk_discount_1))
    expect(page).to have_content("All fields must be completed, get your act together.")
  end
end
