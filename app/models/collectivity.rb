class Collectivity < ApplicationRecord
  enum :status, {active: "active", inactive: "inactive"}
  validates :name, :siret, :code_cog, :status, presence: true
  validates :siret, siret: true, uniqueness: true

  has_many :shipments, dependent: :destroy
end
