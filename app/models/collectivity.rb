class Collectivity < ApplicationRecord
  TEST_SIRETS = %w[11111111111111 11111111111112].freeze

  enum :status, {active: "active", inactive: "inactive"}
  validates :name, :siret, :code_cog, :status, presence: true
  validates :siret, uniqueness: true
  validates :siret, siret: true, unless: -> { test_siret? }

  has_many :shipments, dependent: :destroy

  def test_siret?
    TEST_SIRETS.include?(siret)
  end
end
