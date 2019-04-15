class MainsController < ApplicationController

  def index
    published_date = params[:published_date].presence || Time.zone.now
    @articles = Article.current_published_on(published_date).published.or(Article.current_published_on(published_date).include_draft_is_mine(current_user))
  end
end
