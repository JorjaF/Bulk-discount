class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end
  
  def create
    # TODO: add sad path if user enters invalid data
    @merchant = Merchant.find(params[:merchant_id])
    BulkDiscount.create!(name: params[:name],
                percentage: params[:percentage],
                quantity: params[:quantity],
                merchant: @merchant)
    redirect_to merchant_bulk_discounts_path(@merchant) 
  end

  private
  
  def item_params
    params.require(:bulk_discount).permit(:name, :percentage, :quantity, :merchant_id)
  end
end
