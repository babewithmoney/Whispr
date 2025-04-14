class ReactionsController < ApplicationController
  def create
    @confession = Confession.find(params[:confession_id])
    @reaction = @confession.reactions.build(reaction_params)
    @reaction.ip_address = request.remote_ip

    respond_to do |format|
      if @reaction.save
        format.turbo_stream
        format.html { redirect_to root_path, notice: 'Thanks for reacting! 🎉' }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("flash", 
            partial: "shared/flash", 
            locals: { 
              message: "You've already shared your reaction to this confession! 😊", 
              type: "alert" 
            })
        end
        format.html { redirect_to root_path, alert: "You've already shared your reaction to this confession! 😊" }
      end
    end
  end

  private

  def reaction_params
    params.require(:reaction).permit(:reaction_type)
  end
end
