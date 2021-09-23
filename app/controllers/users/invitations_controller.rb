class Users::InvitationsController < Devise::InvitationsController
  private

  # This is called when creating invitation.
  # It should return an instance of resource class.
  def invite_resource
    Rails.logger.info "####"
    Rails.logger.info "Mailgun: #{ENV['MAILGUN_API_URL']}"
    Rails.logger.info "####"

    super { |user| ActiveSupport::Notifications.instrument('invited.user', user) }
  end

  # This is called when accepting invitation.
  # It should return an instance of resource class.
  def accept_resource
    resource = resource_class.accept_invitation!(update_resource_params)

    ActiveSupport::Notifications.instrument('accepted.user', resource)

    resource
  end
end
