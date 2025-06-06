class MangaFinderTool < RubyLLM::Tool
  description "Finds a manga in the database, based on an title"
  param :title, desc: "Manga title (e.g. Associations)"

  def execute(title:)
    @manga = Manga.find_by(title: title)
    @manga.as_json(only: :title).merge(url: manga_url)
  rescue => e
    { error: e.message }
  end

  private

  def manga_url
    Rails.application.routes.url_helpers.manga_url(@manga)
  end
end
