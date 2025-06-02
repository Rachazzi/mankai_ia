class CreateMangas < ActiveRecord::Migration[7.1]
  def change
    create_table :mangas do |t|
      t.string :title
      t.string :author
      t.integer :volume
      t.integer :chapter
      t.string :category
      t.text :overview
      t.string :image_url
      t.string :status

      t.timestamps
    end
  end
end
