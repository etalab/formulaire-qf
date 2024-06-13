require "rails_helper"

RSpec.describe ClearCurrentAttributes, type: :interactor do
  subject(:interactor) { described_class.call }

  before do
    Current.user = "user"
    Current.pivot_identity = "pivot_identity"
    Current.quotient_familial = "quotient_familial"
  end

  it "clears the user session" do
    expect { interactor }.to change { Current.user }.from("user").to(nil)
      .and change { Current.pivot_identity }.from("pivot_identity").to(nil)
      .and change { Current.quotient_familial }.from("quotient_familial").to(nil)
  end
end
