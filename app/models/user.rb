# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string(255)
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  provider               :string(255)
#  uid                    :string(255)
#  name                   :string(255)
#

class User < ActiveRecord::Base
  has_many :goods, dependent: :destroy
  accepts_nested_attributes_for :goods
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

  def self.from_omniauth(access_token)
    user = User.where(provider: access_token.provider, uid: access_token.uid).first
    # Find user using provider and unique id
    # If not found, create a new user with the following data    
    unless user
      user = User.create(
        provider: access_token.provider,
        uid:      access_token.uid,
        name:     access_token.info.name,
        email:    access_token.info.email,
        password: Devise.friendly_token[0,20]
      )
    end
    user
  end
end
