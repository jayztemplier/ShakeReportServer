class Reports::CommentsController < ::CommentsController

  def create
    @comment = @model.create_comment!(params[:comment])
    if @comment.save
      flash[:notice] = 'Comment was successfully created.'
    else
      flash[:error] = 'Comment wasn\'t created.'
    end
    redirect_to :back
  end

end