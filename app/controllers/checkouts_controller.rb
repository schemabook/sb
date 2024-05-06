class CheckoutsController < ApplicationController
  before_action :define_business

  # rubocop:disable Metrics/MethodLength
  def new
    return unless current_user.admin?

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
    return unless current_user.admin?

    if params[:session_id] == @business.session_id
      # get checkout session, with reference to customer
      session = Stripe::Checkout::Session.retrieve params[:session_id]
      customer = session[:customer]
      subscription = session[:subscription]

      @business.update(subscribed_at: DateTime.now, subscription_id: subscription, customer_id: customer)

      Events::Businesses::Updated.new(business: @business, user: current_user).publish
    else
      Rails.logger.info "success endpoint hit without matching session for customer: #{@business.id}"
    end

    redirect_to edit_business_path(@business)
  end

  def delete
    return unless current_user.admin?

    subscription = Stripe::Subscription.retrieve @business.subscription_id
    subscription.cancel

    @business.update(cancelled_at: DateTime.now)

    Events::Businesses::Updated.new(business: @business, user: current_user).publish

    redirect_to edit_business_path(@business)
  end

  private

  def define_business
    @business = current_user.business
  end
end
