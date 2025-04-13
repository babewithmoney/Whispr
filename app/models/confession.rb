class Confession < ApplicationRecord
  has_many :reactions, dependent: :destroy

  validates :body, presence: true, length: { maximum: 500 }
  validates :ip_address, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :trending, -> { order(reactions_count: :desc, created_at: :desc) }

  def reaction_types_count
    reactions.group(:reaction_type).count
  end
end
