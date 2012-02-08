class SubscriptionsController < ApplicationController

  before_filter :authenticate_user!

  def create
    @subscription      = Subscription.new params[:subscription]
    @subscription.user = current_user

    @plan = Plan.find params[:subscription][:plan_id]

    if @subscription.save_with_payment
      flash[:success] = 'Subscription added!'
      redirect_to root_path
    else
      flash.now[:error] = 'Unable to add subscription!'
      render template: 'plans/show'
    end
  end

  def edit
    @subscription = current_user.subscription
  end

  def update
    @subscription = current_user.subscription

    if @subscription.update_with_payment params[:subscription]
      flash.now[:success] = 'Subscription updated!'
      redirect_to root_path
    else
      flash.now[:error] = 'Unable to update billing!'
      render :edit
    end
  end

end
