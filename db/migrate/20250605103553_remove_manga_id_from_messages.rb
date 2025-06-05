class RemoveMangaIdFromMessages < ActiveRecord::Migration[7.1]
  def change
    remove_reference :messages, :manga, null: false, foreign_key: true
  end
end
