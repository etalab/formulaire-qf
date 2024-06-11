class User
  attr_reader :access_token, :sub

  def initialize(access_token: nil, sub: nil)
    @access_token = access_token
    @sub = sub
  end

  def authenticated?
    sub.present?
  end
end
