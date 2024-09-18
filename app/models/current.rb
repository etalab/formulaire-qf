class Current < ActiveSupport::CurrentAttributes
  attribute :pivot_identity,
            :original_pivot_identity,
            :quotient_familial,
            :collectivity,
            :user,
            :external_id,
            :redirect_uri
end
