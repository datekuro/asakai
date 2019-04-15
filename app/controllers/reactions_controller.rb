class ReactionsController < ApplicationController

  before_action :authenticate_user!

  # POST /reactions
  # POST /reactions.json
  def create
    @reaction = Reaction.create_with(code: reaction_params[:code]).find_or_create_by(reaction_params.merge!({ user: current_user }))
    if @reaction.toggle!(:registered)
      render json: {
        reactionable_id: @reaction.reactionable_id,
        reactionable_type: @reaction.reactionable_type,
        body: render_to_string(partial: 'reactions/reaction_list', collection: @reaction.reactionable.grouped_active_reactions, as: :grouped_reaction),
        status: :created
      }.to_json
    else
      format.json { render json: { errors: @reaction.errors.full_messages }, status: :unprocessable_entity }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def reaction_params
      params.require(:reaction).permit(:code, :reactionable_type, :reactionable_id)
    end
end
