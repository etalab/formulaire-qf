class User
  attr_reader :access_token, :sub, :first_names, :last_name

  def initialize(access_token: nil, sub: nil, first_names: nil, last_name: nil)
    @access_token = access_token
    @sub = sub
    @first_names = first_names
    @last_name = last_name
  end

  def authenticated?
    sub.present?
  end

  def display_name
    "#{@first_names} #{@last_name}"
  end
end
