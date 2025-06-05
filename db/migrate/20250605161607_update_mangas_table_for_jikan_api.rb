class UpdateMangasTableForJikanApi < ActiveRecord::Migration[7.1]
  def up
    # Ajouter d'abord les colonnes sans contrainte NOT NULL
    add_column :mangas, :jikan_id, :integer
    add_column :mangas, :title_english, :string
    add_column :mangas, :genre, :string
    add_column :mangas, :synopsis, :text, limit: 1000
    add_column :mangas, :score, :decimal, precision: 3, scale: 1

    # Renommer les colonnes existantes pour correspondre à l'API Jikan
    rename_column :mangas, :volume, :volumes
    rename_column :mangas, :chapter, :chapters
    rename_column :mangas, :overview, :synopsis_old # Garder temporairement

    # Supprimer les colonnes qui ne sont plus utilisées
    remove_column :mangas, :author, :string
    remove_column :mangas, :category, :string

    # Si vous voulez supprimer les données existantes et recommencer :
    # Manga.delete_all

    # Ou si vous voulez garder les données, assignez des valeurs par défaut :
    # Manga.update_all(jikan_id: 0) # Valeur temporaire

    # Ensuite ajouter la contrainte NOT NULL et l'index
    change_column_null :mangas, :jikan_id, false
    add_index :mangas, :jikan_id, unique: true

    # Optionnel : ajouter un index sur le score pour les recherches/tri
    add_index :mangas, :score
  end

  def down
    # Restaurer l'ancien schéma
    remove_index :mangas, :jikan_id
    remove_index :mangas, :score

    add_column :mangas, :author, :string
    add_column :mangas, :category, :string

    rename_column :mangas, :volumes, :volume
    rename_column :mangas, :chapters, :chapter
    rename_column :mangas, :synopsis_old, :overview

    remove_column :mangas, :jikan_id
    remove_column :mangas, :title_english
    remove_column :mangas, :genre
    remove_column :mangas, :synopsis
    remove_column :mangas, :score
  end
end
