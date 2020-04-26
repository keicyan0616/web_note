class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         #:confirmable, :lockable, :timeoutable, :omniauthable, omniauth_providers: [:twitter]
         :lockable, :timeoutable, :omniauthable, omniauth_providers: [:twitter]

  # validates :name, presence: true, length: { maximum: 50 }
  
  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  #has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  def self.from_omniauth(auth)
    where(provider: auth["provider"], uid: auth["uid"]).first_or_create do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.username = auth["info"]["nickname"]
    end
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      #new(session["devise.user_attributes"], without_protection: true) do |user|
      new session["devise.user_attributes"] do |user|
          user.attributes = params
          user.valid?
      end
    else
      super
    end
  end
  
  # ユーザーを絞り込み検索します。
  def self.search(search)
    if search && search != ""
      where(['username LIKE ?', "%#{search}%"])
    else
      all
    end
  end
end