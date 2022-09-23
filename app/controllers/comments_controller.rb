class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params.merge(user_id: current_user.id))

    if @comment.save
      Events::Comments::Created.new(record: @comment, user: current_user).publish

      flash[:notice] = "Comment was addedd"
    else
      flash[:alert] = "Comment could not be added"
    end

    redirect_to schema_path(@comment.version.schema, version: @comment.version.index)
  end

  private

  def comment_params
    # NOTE: use version id versus index
    params.require(:comment).permit(:user_id, :version_id, :body)
  end
end
