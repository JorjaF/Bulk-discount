require "rails_helper"

RSpec.describe "bulk discount index" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Jewelry Jar")
    @bulk_discount_1 = BulkDiscount.create!(name: "Fire Sale", percentage: 0.1, quantity: 10, merchant_id: @merchant1.id)
    @bulk_discount_2 = BulkDiscount.create!(name: "Going Out of Business", percentage: 0.25, quantity: 20, merchant_id: @merchant1.id)
    @bulk_discount_3 = BulkDiscount.create!(name: "Spring Fling", percentage: 0.30, quantity: 100, merchant_id: @merchant2.id)
  end

  it "can add a new bulk discount" do
    
    visit merchant_bulk_discounts_path(@merchant1)
        
    click_link 'Create New Discount'
    
    expect(page).to have_content('New Bulk Discount')

    fill_in 'Name', with: 'New Discount'
    fill_in 'percentage', with: '.15'
    fill_in 'Quantity', with: '25'
    click_button 'Submit'

    expect(page).to have_content('Bulk Discounts Index')

    expect(page).to have_content('New Discount')
    expect(page).to have_content('Percentage: 15%')
    expect(page).to have_content('Quantity: 25')
  end

  it "can delete a bulk discount" do
    expect(@merchant1.bulk_discounts.count).to eq(2)
    expect(@bulk_discount_1.name).to eq("Fire Sale")
    expect(@bulk_discount_2.name).to eq("Going Out of Business")

    visit merchant_bulk_discounts_path(@merchant1)
      
      click_link "Delete", match: :first
    
    expect(page).to have_current_path(merchant_bulk_discounts_path(@merchant1))
    expect(page).not_to have_content(@bulk_discount_1.name)
    expect(page).to have_content(@bulk_discount_2.name)
  end
end