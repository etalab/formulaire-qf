require "rails_helper"

RSpec.describe Collectivity, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:siret) }
  it { is_expected.to validate_presence_of(:code_cog) }
  it { is_expected.to validate_presence_of(:status) }

  it { is_expected.to define_enum_for(:status).with_values(active: "active", inactive: "inactive").backed_by_column_of_type(:string) }
end
