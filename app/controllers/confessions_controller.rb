class ConfessionsController < ApplicationController
  before_action :check_rate_limit, only: [:create]

  def index
    @confession = Confession.new
    @confessions = if params[:tab] == 'trending'
      # Get top 20 posts by total reactions
      Confession.joins(:reactions)
               .group('confessions.id')
               .select('confessions.*, COUNT(reactions.id) as reactions_count')
               .having('COUNT(reactions.id) >= ?', 50)
               .order('reactions_count DESC')
               .limit(20)
    else
      Confession.recent.limit(20)
    end
  end

  def create
    @confession = Confession.new(confession_params)
    @confession.ip_address = request.remote_ip

    if @confession.save
      redirect_to root_path, notice: 'Your confession has been shared!'
    else
      redirect_to root_path, alert: @confession.errors.full_messages.join(', ')
    end
  end

  private

  def confession_params
    params.require(:confession).permit(:body)
  end

  def check_rate_limit
    daily_count = Confession.where(ip_address: request.remote_ip)
                           .where('created_at > ?', 24.hours.ago)
                           .count

    if daily_count >= 3
      redirect_to root_path, alert: 'You can only post 3 confessions per day'
      return
    end
  end
end
