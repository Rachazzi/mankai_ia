class Chat < ApplicationRecord
  has_many :messages, dependent: :destroy
  belongs_to :user
  # optional: true permet ici de pas avoir d'erreur si le sujet de la consertion avec le chatbot -
  # - n'est pas lié a un manga_id
  belongs_to :manga, optional: true
end
