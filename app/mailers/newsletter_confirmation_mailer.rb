class NewsletterConfirmationMailer < ApplicationMailer
  def confirmation_email
    @newsletter = params[:newsletter_instance]
    @generated_hash = opt_in_hash(@newsletter)
    @url = "http://localhost:3000/newsletters?hash=#{@generated_hash}"

    mail(to: @newsletter.email, from: "newsletter@schemabook.com", subject: "Please confirm your Schemabook newsletter subscription")
  end

  private

  def opt_in_hash(newsletter_instance)
    Mailgun::OptInHandler.generate_hash(Newsletter::MAILING_LIST, Newsletter::LIST_SALT, newsletter_instance.email)
  end
end