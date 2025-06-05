class RemoveResponseFromMessages < ActiveRecord::Migration[7.1]
  def change
    remove_column :messages, :response, :text
  end
end
