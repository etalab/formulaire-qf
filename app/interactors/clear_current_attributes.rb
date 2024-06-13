class ClearCurrentAttributes < BaseInteractor
  def call
    Current.user = nil
    Current.pivot_identity = nil
    Current.quotient_familial = nil
  end
end
