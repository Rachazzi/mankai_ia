class Manga < ApplicationRecord
  # Un manga peut avoir plusieurs chats, si on supprime un manga je supprime tous les chats qui lui sont associés.
  # Attention : ici on peut utiliser nullify a la place de destroy si on veut garder l'historique de conversation.
  has_many :chats, dependent: :destroy
end
