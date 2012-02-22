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
    @purchase = Purchase.new :user              => current_user,
                             :item              => Item.find(params[:purchase][:item_id])

    if @purchase.save_with_payment params[:purchase][:stripe_card_token]
      flash[:success] = "Thanks for purchasing!"
      redirect_to purchases_path
    else
      flash[:error]   = "Could not process purchase"
      render :new
    end
  end

end
