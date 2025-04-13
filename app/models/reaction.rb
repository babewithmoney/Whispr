class Reaction < ApplicationRecord
  belongs_to :confession, counter_cache: true

  VALID_TYPES = %w[like hug laugh].freeze

  validates :reaction_type, presence: true, inclusion: { in: VALID_TYPES }
  validates :ip_address, presence: true
  validates :confession_id, uniqueness: { scope: :ip_address,
    message: "You have already reacted to this confession" }

  after_create :update_confession_counter
  after_destroy :update_confession_counter

  private

  def update_confession_counter
    confession.update_columns(
      reactions_count: confession.reactions.count
    )
  end
end
