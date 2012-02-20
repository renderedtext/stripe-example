require 'spec_helper'

describe WebhookController do

  describe 'receiving webhooks from stripe' do

    before do
      @hash = load_webhook_json 'invoice.payment_failed'
      post :index, @hash
      @webhook = Webhook.last
    end

    it 'returns 200' do
      response.status.should == 200
    end

    it 'an empty body' do
      response.body.should == ' '
    end

    it 'sets the stripe_event_id' do
      @webhook.stripe_webhook_id.should == @hash['id']
    end

    it 'sets the stripe_event_type' do
      @webhook.stripe_webhook_type.should == @hash['type']
    end

    it 'sets "livemode" flag' do
      @webhook.livemode.should == @hash['livemode']
    end

    it 'caches the data object' do
      pending 'Serilization does creepy things with my datatypes: http://stackoverflow.com/questions/9087068/how-to-test-json-serialization-in-activerecord'
      @webhook.object.should == @hash['data']['object']
    end

  end

end
