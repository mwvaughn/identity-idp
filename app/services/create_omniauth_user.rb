CreateOmniauthUser = Struct.new(:email) do
  def perform
    User.find_or_create_by(email: email) do |user|
      user.update(confirmed_at: Time.current)
    end
  end
end