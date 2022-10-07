class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    @url  = 'http://www.schemabook.com/users/sign_in'

    mail(to: @user.email, subject: 'Welcome to Schemabook')
  end
end
