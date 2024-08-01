class NewslettersController < ApplicationController
  layout 'public'

  skip_before_action :authenticate_user!

  def create
    @newsletter = Newsletter.new(email: newsletter_params)

    respond_to do |format|
      if @newsletter.save
        send_confirmation(@newsletter)
        add_to_mailing_list(@newsletter)

        format.json { render json: @newsletter, status: :created }
      else
        format.json { render json: @newsletter.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @hash = params[:hash]
    hash_validation = Mailgun::OptInHandler.validate_hash(Newsletter::LIST_SALT, @hash)

    redirect_to home_url && return if hash_validation.nil?

    validated_list = hash_validation['mailing_list']
    validated_recipient = hash_validation['recipient_address']

    params = {
      address: validated_recipient,
      subscribed: 'yes'
    }

    mailgun_client.put("lists/#{validated_list}/members/#{validated_recipient}", params)

    @posts = BlogController::POSTS.sort_by { |post| post[:date] }.reverse
  end

  private

  def newsletter_params
    params.require(:emailAddress)
  end

  def send_confirmation(newsletter_instance)
    NewsletterConfirmationMailer.with(newsletter_instance:).confirmation_email.deliver_now
  end

  def mailgun_client
    Mailgun::Client.new(ENV.fetch("MAILGUN_API_KEY"))
  end

  def add_to_mailing_list(newsletter_instance)
    params = {
      address: newsletter_instance.email,
      subscribed: 'no',
      upsert: 'yes'
    }

    mailgun_client.post("lists/#{Newsletter::MAILING_LIST}/members", params)
  end
end