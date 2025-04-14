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
      .group('confessions.id')
      .select(
        'confessions.*, ' \
        'COUNT(reactions.id) as total_reactions, ' \
        'COUNT(CASE WHEN reactions.created_at > ? THEN 1 END) as recent_reactions, ' \
        '(COUNT(CASE WHEN reactions.created_at > ? THEN 1 END) * 1.5 + ' \
        'COUNT(reactions.id)) / POWER(EXTRACT(EPOCH FROM (now() - confessions.created_at)) / 3600 + 2, 1.5) ' \
        'as trending_score',
        24.hours.ago,
        24.hours.ago
      )
      .having('COUNT(reactions.id) >= 5') # Minimum reactions threshold
      .order('trending_score DESC')
      .limit(20)
  }

  def trending?
    return false if reactions.count < 5
    
    total_count = reactions.count
    recent_count = reactions.where('created_at > ?', 24.hours.ago).count
    hours_since_creation = ((Time.current - created_at) / 1.hour).round
    
    # Calculate trending score
    trending_score = (recent_count * 1.5 + total_count) / ((hours_since_creation + 2) ** 1.5)
    
    # Post is trending if it has a good score and some recent activity
    trending_score > 0.5 && recent_count > 0
  end

  def reaction_types_count
    reactions.group(:reaction_type).count
  end
end
