describe User, type: :model do
  subject(:user) { described_class.new(access_token: access_token, sub: sub) }

  let(:access_token) { "some_real_token" }
  let(:sub) { "some_real_sub" }

  describe "API" do
    it { is_expected.to respond_to(:access_token) }
    it { is_expected.to respond_to(:sub) }
  end

  describe "#authenticated?" do
    subject(:authenticated?) { user.authenticated? }

    context "when the user is authenticated" do
      it { is_expected.to be true }
    end

    context "when the user is not authenticated" do
      let(:access_token) { nil }
      let(:sub) { nil }

      it { is_expected.to be false }
    end
  end
end
