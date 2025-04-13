class ReactionsController < ApplicationController
  def create
    @confession = Confession.find(params[:confession_id])
    @reaction = @confession.reactions.build(reaction_params)
    @reaction.ip_address = request.remote_ip

    respond_to do |format|
      if @reaction.save
        format.turbo_stream
        format.html { redirect_to root_path, notice: 'Reaction added!' }
      else
        format.html { redirect_to root_path, alert: @reaction.errors.full_messages.join(', ') }
      end
    end
  end

  private

  def reaction_params
    params.require(:reaction).permit(:reaction_type)
  end
end
