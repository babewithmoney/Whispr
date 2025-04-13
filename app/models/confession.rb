class Confession < ApplicationRecord
  has_many :reactions, dependent: :destroy

  validates :body, presence: true, length: { maximum: 500 }
  validates :ip_address, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :trending, -> {
    select("confessions.*, 
            (reactions_count * 10.0 + 100.0 / (1 + extract(epoch from now() - created_at) / 3600.0)) as trending_score")
      .order("trending_score DESC")
  }

  def reaction_types_count
    reactions.group(:reaction_type).count
  end
end
