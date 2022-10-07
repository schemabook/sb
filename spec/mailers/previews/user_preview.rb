# Preview all emails at http://localhost:3000/rails/mailers/user
class UserPreview < ActionMailer::Preview
  def welcome_email
    UserMailer.with(user: User.last).welcome_email
  end

  def invitation_instructions
    Devise::Mailer.invitation_instructions(User.where.not(invited_by_id: nil).first, "faketoken")
  end
end
