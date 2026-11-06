require "rails_helper"

RSpec.describe PurgeExpiredSessionsJob, type: :job do
  describe "#perform" do
    subject(:job) { described_class.perform_now }

    let!(:stale_session) { create_session(updated_at: 24.hours.ago) }
    let!(:fresh_session) { create_session(updated_at: 22.hours.ago) }

    def create_session(updated_at:)
      ActiveRecord::SessionStore::Session.create!(session_id: SecureRandom.hex, data: {}, updated_at:)
    end

    it "deletes the sessions idle for more than 23 hours" do
      job

      expect(ActiveRecord::SessionStore::Session.exists?(stale_session.id)).to be(false)
    end

    it "keeps the sessions written in the last 23 hours" do
      job

      expect(ActiveRecord::SessionStore::Session.exists?(fresh_session.id)).to be(true)
    end
  end
end
