class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end
  
  def create
    @merchant = Merchant.find(params[:merchant_id])
    bulk_discount = BulkDiscount.create(name: params[:name],
                percentage: params[:percentage],
                quantity: params[:quantity],
                merchant: @merchant)
    if bulk_discount.save
      flash.notice = "Succesfully Created New Bulk Discount!"
      redirect_to merchant_bulk_discounts_path(@merchant) 
    else
      flash.alert = "All fields must be completed, get your act together."
      redirect_to new_merchant_bulk_discount_path(@merchant)
    end
  end

  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.find(params[:id])
    @bulk_discount.destroy!
    redirect_to merchant_bulk_discounts_path
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.find(params[:id])

    if @bulk_discount.update(bulk_discount_params)
      flash.notice = "Succesfully Updated Bulk Discount Info!"
      redirect_to merchant_bulk_discount_path(@merchant, @bulk_discount)
    else
      flash.notice = "All fields must be completed, get your act together."
      redirect_to merchant_bulk_discount_path(@merchant, @bulk_discount)
    end
  end

  private

  def bulk_discount_params
    params.require(:bulk_discount).permit(:name, :percentage, :quantity, :merchant_id)
  end
end
