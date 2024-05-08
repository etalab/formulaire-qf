class ClaimsController < ApplicationController
  def index
  end

  def quotient_familial
    result = GetFamilyQuotient.call(identity: Current.user)

    if result.success?
      session["qf"] = result.qf
      Current.quotient_familial = result.qf
    else
      raise
    end
  end

  def send_qf
    recipient = Hubee::Recipient.new(siren: "21040107100019", branch_code: "04107")

    result = StoreQuotientFamilial.call(identity: Current.user, quotient_familial: Current.quotient_familial, recipient: recipient)

    if result.success?
      Rails.logger.debug "Noïce"
      @folder = result.folder
    else
      raise
    end
  end
end
