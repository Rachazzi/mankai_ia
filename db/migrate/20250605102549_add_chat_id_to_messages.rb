class AddChatIdToMessages < ActiveRecord::Migration[7.1]
  def change
    add_reference :messages, :chat, foreign_key: true
  end
end
