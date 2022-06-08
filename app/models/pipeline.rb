class Pipeline < ApplicationRecord
  belongs_to :user

  validates :name, presence: true

  scope :reverse_chronological, -> { order(created_at: :desc) }

  has_many :saved_candidates, dependent: :destroy
  has_many :candidates, through: :saved_candidates
end
