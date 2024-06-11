class ClaimsController < ApplicationController
  def index
  end

  def quotient_familial
    result = GetFamilyQuotient.call(recipient: Current.recipient, user: Current.user)

    if result.success?
      session["quotient_familial"] = result.quotient_familial
      Current.quotient_familial = result.quotient_familial
    else
      raise
    end
  end

  def send_qf
    hubee_recipient = HubEE::Recipient.new(siren: "21040107100019", branch_code: "04107")

    result = StoreQuotientFamilial.call(identity: Current.pivot_identity, quotient_familial: Current.quotient_familial, recipient: hubee_recipient)

    if result.success?
      Rails.logger.debug "Noïce"
      @folder = result.folder
    else
      raise
    end
  end
end
