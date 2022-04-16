class Users::InvitationsController < Devise::InvitationsController
  private

  # This is called when creating invitation.
  # It should return an instance of resource class.
  def invite_resource
    resource = super { |user| ActiveSupport::Notifications.instrument('invited.user', user) }

    # notify subscribers
    Events::Invitations::Created.new(teammate: resource, user: current_user).publish

    resource
  end

  # This is called when accepting invitation.
  # It should return an instance of resource class.
  def accept_resource
    resource = resource_class.accept_invitation!(update_resource_params)

    ActiveSupport::Notifications.instrument('accepted.user', resource)

    resource
  end
end
