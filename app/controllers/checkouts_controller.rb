class CheckoutsController < ApplicationController
  before_action :define_business

  # rubocop:disable Metrics/MethodLength
  def new
    prices = Stripe::Price.list(lookup_keys: ["subscription"], expand: ["data.product"])

    begin
      params = {
        mode: "subscription",
        line_items: [{
          quantity: 1,
          price: prices.data[0].id
        }],
        success_url: "#{ENV.fetch('STRIPE_DOMAIN')}/checkouts/success?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: "#{ENV.fetch('STRIPE_DOMAIN')}/checkouts/cancel"
      }
      session = Stripe::Checkout::Session.create(params)
    rescue StandardError => e
      return [
        400, { "Content-Type" => "application/json" },
        [ { status: 400, error: e.message }.to_json ]
      ]
    end

    @business.update(session_id: session.id)

    redirect_to session.url
  end
  # rubocop:enable Metrics/MethodLength

  def create
  end

  def success
    @business.update(subscribed_at: DateTime.now) if params[:session_id] == @business.session_id
    # TODO: check the Stripe API in the future

    Events::Businesses::Updated.new(business: @business, user: current_user).publish

    redirect_to edit_business_path(@business)
  end

  def cancel
    @business.update(session_id: null)

    redirect_to edit_business_path(@business)
  end

  private

  def define_business
    @business = current_user.business
  end
end
