class CommentsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_comment, only: [:destroy]

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    article = Article.find(params[:article_id])
    article_comment = @comment.article_comments.build
    article_comment.article = article
    respond_to do |format|
      if @comment.save
        format.html { render json: { article_id: article.id, body: render_to_string(partial: 'comments/index', collection: article.comments.latest, as: :comment), status: :created }.to_json }
      else
        format.html { render :new }
        format.json { render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    article = Article.find(params[:article_id])
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to (request.referer.presence || root_path), notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:user_id, :body)
    end
end
