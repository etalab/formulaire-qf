RSpec.describe Shipment, type: :model do
  it { is_expected.to validate_presence_of(:reference) }

  it { is_expected.to define_enum_for(:hubee_status).with_values(pending: "pending", in_progress: "in_progress", done: "done", refused: "refused").backed_by_column_of_type(:string) }
end
