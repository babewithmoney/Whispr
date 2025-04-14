class Confession < ApplicationRecord
  has_many :reactions, dependent: :destroy

  validates :body, presence: true, length: { maximum: 500 }
  validates :ip_address, presence: true

  scope :recent, -> { order(created_at: :desc) }
  
  # Trending posts are determined by:
  # 1. Recent reactions (weighted more heavily)
  # 2. Total reaction count
  # 3. Time decay factor
  scope :trending, -> {
    joins(:reactions)
      .group('confessions.id, confessions.created_at, confessions.body, confessions.ip_address')
      .select(
        'confessions.*, ' \
        'COUNT(DISTINCT reactions.id) as total_reactions_count'
      )
      .having('COUNT(DISTINCT reactions.id) >= ?', 15)
      .order(Arel.sql('COUNT(DISTINCT CASE WHEN reactions.created_at > NOW() - INTERVAL \'24 hours\' THEN reactions.id END) DESC'))
      .limit(20)
  }

  def trending?
    return false unless reactions.exists?

    # Get counts using explicit timezone handling
    total_reactions = reactions.count
    recent_reactions = reactions.where('reactions.created_at > ?', 24.hours.ago).count
    hours_old = ((Time.current - created_at) / 1.hour).round

    # Basic thresholds
    return false if total_reactions < 15
    return false if recent_reactions == 0
    return false if hours_old > 72 # Don't show trending after 3 days

    # Calculate score - simpler but effective formula
    score = (recent_reactions * 2.0 + total_reactions) / Math.sqrt(hours_old + 2)
    
    # Post is trending if it has a good engagement ratio
    recent_ratio = recent_reactions.to_f / total_reactions
    score > 3.0 && recent_ratio > 0.1
  end

  def reaction_types_count
    reactions.group(:reaction_type).count
  end
end
