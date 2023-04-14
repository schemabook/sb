# Preview all emails at http://localhost:3000/rails/mailers/user
class UserPreview < ActionMailer::Preview
  def welcome_email
    UserMailer.with(user: User.last).welcome_email
  end

  def invitation_instructions
    Devise::Mailer.invitation_instructions(User.where.not(invited_by_id: nil).first, "faketoken")
  end

  def new_version_email
    UserMailer.with(user: User.last, version: Version.last).new_version_email
  end

  def new_comment_email
    UserMailer.with(comment: Comment.last, user: User.last, schema: Version.last.schema, version: Version.last, team: Version.last.schema.team).new_version_email
  end
end
