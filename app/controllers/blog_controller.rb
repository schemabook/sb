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
