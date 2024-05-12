class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  # Signing up for the system is disabled.
  # Only system/institution admins can create new users
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
