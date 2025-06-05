class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  # Un utilisateur a plusieurs chats, si je supprime un utilisateur alors je supprime les chats qui lui sont associés
  has_many :chats, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
