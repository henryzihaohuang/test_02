class UserSession
  include ActiveModel::Validations

  attr_accessor :email,
                :password

  validates :email, presence: true
  validates :password, presence: true

  validate :user_exists
  validate :user_is_authenticated

  def initialize(attributes)
    @email = attributes[:email]
    @password = attributes[:password]
  end

  def user
    @user ||= User.where('lower(email) = ?', @email.downcase).first
  end

  private

  def user_exists
    return if self.errors[:email].any?

    unless self.user
      self.errors.add :email, 'does not exist'
    end
  end

  def user_is_authenticated
    return if self.errors[:password].any?

    unless self.user.try(:authenticate, @password)
      self.errors.add :password, 'is incorrect'
    end
  end
end