class BlogController < ApplicationController
  layout 'public'

  skip_before_action :authenticate_user!

  POSTS = [
    {
      file: "why.md",
      slug: "why",
      date: Date.new(2024, 7, 29),
      title: "Why we are building Schemabook",
      intro: "Schemabook's ultimate goal is to make data more actionable through improving collaboration and improving quality. While building a central component of the data platform at a Fortune 100 company, Schemabook's founder experienced first hand how much effort and cost went into collecting data that the business could not immediately act on or just could not use."
    },
    {
      file: "stakeholders.md",
      slug: "stakeholders",
      date: Date.new(2024, 10, 8),
      title: "We're focusing on stakeholders",
      intro: "When it comes to data within an organization, there are typically two main groups of stakeholders: the producers and the consumers. In many organizations, there is a disconnect between these two groups, with data often being thrown over the fence from one to the other without any collaboration."
    }
  ]

  def index
    @posts = POSTS.sort_by { |post| post[:date] }.reverse
  end

  def show
    @post = POSTS.find { |post| post[:slug] == params[:id] }

    redirect_to action: "index" if @post.nil?
  end
end
