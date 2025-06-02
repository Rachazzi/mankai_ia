class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.text :content
      t.references :manga, null: false, foreign_key: true
      t.string :role

      t.timestamps
    end
  end
end
