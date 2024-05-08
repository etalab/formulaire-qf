require "rails_helper"

RSpec.describe StoreQuotientFamilial, type: :organizer do
  let(:interactors) do
    [
      Hubee::CreateFolder,
    ]
  end

  it "setups the folder, sends it to HubEE and cleans afterwards" do
    expect(described_class).to organize interactors
  end
end
