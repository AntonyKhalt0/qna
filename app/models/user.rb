class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [:github, :vkontakte]
         
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :awards, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  def author?(resource)
    self == resource.author
  end

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call    
  end

  def self.find_by_authorization(auth)
    joins(:authorizations).where(authorizations: { provider: auth['provider'], uid: auth['uid'] }).first
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth[:provider], uid: auth[:uid].to_s)
  end

  def self.build_vkontakte_auth_hash(auth)
    {
      provider: auth[:provider],
      uid: auth[:uid],
      access_token: auth['credentials']['token']
    }
  end
end
