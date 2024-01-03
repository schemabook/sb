class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    @url = "http://www.schemabook.com/users/sign_in"

    mail(to: @user.email, from: "stakeholder@schemabook.com", subject: "Welcome to Schemabook")
  end

  def notification_email
    @business = params[:business]

    mail(to: "support@schemabook.com", from: "notifications@schemabook.com", subject: "Business Created")
  end

  def new_service_email
    @user = params[:user]
    @service = params[:service]
    @team = @service.team
    @teammates = @team.users - [@user]
    @url = "http://www.schemabook.com/services/#{@service.public_id}"

    @teammates.each do |mate|
      mail(to: mate.email, from: "stakeholder@schemabook.com", subject: "New Service Created")
    end
  end

  def new_version_email
    @user = params[:user]
    @version = params[:version]
    @schema = @version.schema
    @url = "http://www.schemabook.com/schemas/#{@schema.public_id}"
    @stakeholders = @schema.stakeholders - [@user]

    @stakeholders.each do |stakeholder|
      mail(to: stakeholder.user.email, from: "stakeholder@schemabook.com", subject: "New Schema Version Created")
    end
  end

  def new_comment_email
    @comment = params[:comment]
    @user = params[:user]
    @schema = params[:schema]
    @version = params[:version]
    @team = params[:team]
    @url = "http://www.schemabook.com/schemas/#{@schema.public_id}?version=#{@version.index}"

    @team.users.each do |member|
      mail(to: member.email, from: "notifications@schemabook.com", subject: "New Schema Comment")
    end
  end
end
