class MangaFinderTool < RubyLLM::Tool
  description "Finds a manga in the database, based on an image_url"
  param :image_url, desc: "Manga image_url (e.g. Associations)"

  def execute(image_url:)
    @manga = Manga.where(image_url: image_url).first
    @manga.as_json(only: [:image_url, :content]).merge(url: manga_url)
  rescue => e
    { error: e.message }
  end

  private

  def manga_url
    Rails.application.routes.url_helpers.manga_url(@manga)
  end
end
