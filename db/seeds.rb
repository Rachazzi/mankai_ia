# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'net/http'
require 'json'
require 'uri'

puts "🚀 Début du seeding des mangas depuis Jikan API..."

# Fonction pour faire les requêtes API avec gestion d'erreurs
def fetch_manga_page(page)
  uri = URI("https://api.jikan.moe/v4/manga?page=#{page}&limit=25")

  begin
    response = Net::HTTP.get_response(uri)

    if response.code == '200'
      JSON.parse(response.body)
    else
      puts "❌ Erreur API pour la page #{page}: #{response.code}"
      nil
    end
  rescue => e
    puts "❌ Erreur de connexion pour la page #{page}: #{e.message}"
    nil
  end
end

# Fonction pour créer un manga en base
def create_manga(manga_data)
  # Adaptation selon votre modèle Manga
  # Ajustez les attributs selon votre schema
  Manga.find_or_create_by(jikan_id: manga_data['mal_id']) do |manga|
    manga.title = manga_data['title']
    manga.title_english = manga_data['title_english']
    manga.genre = manga_data ['genres']
    manga.synopsis = manga_data['synopsis']&.truncate(1000) # Limiter la taille
    manga.status = manga_data['status']
    manga.chapters = manga_data['chapters']
    manga.volumes = manga_data['volumes']
    manga.score = manga_data['score']
    manga.image_url = manga_data.dig('images', 'jpg', 'large_image_url')
  end
rescue => e
  puts "❌ Erreur lors de la création du manga #{manga_data['title']}: #{e.message}"
  nil
end

# Variables pour le tracking
total_created = 0
total_errors = 0
page = 1
max_manga = 5

puts "📚 Récupération de #{max_manga} mangas..."

while total_created < max_manga
  puts "📄 Traitement de la page #{page}..."

  # Récupérer les données de la page
  data = fetch_manga_page(page)

  if data.nil?
    total_errors += 1
    page += 1

    # Arrêter après 3 pages d'erreurs consécutives
    if total_errors >= 3
      puts "❌ Trop d'erreurs, arrêt du seeding"
      break
    end

    next
  end

  # Reset du compteur d'erreurs si succès
  total_errors = 0

  # Traiter chaque manga de la page
  mangas = data['data']

  if mangas.empty?
    puts "📭 Aucun manga trouvé sur cette page, fin du seeding"
    break
  end

  mangas.each do |manga_data|
    break if total_created >= max_manga

    manga = create_manga(manga_data)

    if manga&.persisted?
      total_created += 1
      puts "✅ Manga créé: #{manga.title} (#{total_created}/#{max_manga})"
    end

    # Respecter les limites de l'API (1 requête par seconde)
    sleep(0.1)
  end

  page += 1

  # Pause entre les pages pour respecter l'API
  sleep(1)
end

puts "🎉 Seeding terminé!"
puts "📊 Statistiques:"
puts "   - Mangas créés: #{total_created}"
puts "   - Pages traitées: #{page - 1}"

# Afficher quelques stats
if Manga.count > 0
  puts "\n📈 Aperçu des données:"
  puts "   - Total mangas en base: #{Manga.count}"
  puts "   - Dernier manga ajouté: #{Manga.last&.title}"
  puts "   - Manga le mieux noté: #{Manga.where.not(score: nil).order(score: :desc).first&.title}"
end
