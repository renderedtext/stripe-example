class PlansController < ApplicationController

  def index
    @plans = Plan.order 'price asc'
    respond_with @plans
  end

  def show
    @plan         = Plan.find_by_slug params[:plan]
    @subscription = Subscription.new
  end

end
