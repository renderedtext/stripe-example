class PurchasesController < ApplicationController

  before_filter :authenticate_user!

  def index
    @purchases = Item.all
  end

  def new
    @purchase = Purchase.new
    @item     = Item.find(params[:item_id])
  end

  def create
    @purchase = current_user.purchases.new params[:purchase]

    if @purchase.save_with_payment 
      flash[:success] = "Thanks for purchasing!"
      redirect_to purchases_path
    else
      flash[:error]   = "Could not process purchase"
      # render :new
    end
  end

end
