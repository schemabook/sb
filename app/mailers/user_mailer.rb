class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    @url  = 'http://www.schemabook.com/users/sign_in'

    mail(to: @user.email, from: 'stakeholder@schemabook.com', subject: 'Welcome to Schemabook')
  end

  def new_service_email
    @user      = params[:user]
    @service   = params[:service]
    @team      = @service.team
    @teammates = @team.users - [@user]
    @url       = "http://www.schemabook.com/services/#{@service.id}"

    @teammates.each do |mate|
      mail(to: mate.email, from: 'stakeholder@schemabook.com', subject: 'New Service Created')
    end
  end

  def new_version_email
    @user      = params[:user]
    @version   = params[:version]
    @schema    = @version.schema
    @stakeholders = @schema.stakeholders - [@user]
    @url       = "http://www.schemabook.com/schema/#{@schema.id}"

    @stakeholders.each do |stakeholder|
      mail(to: stakeholder.user.email, from: 'stakeholder@schemabook.com', subject: 'New Schema Version Created')
    end
  end
end
