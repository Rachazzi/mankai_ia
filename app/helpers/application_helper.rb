module ApplicationHelper
  include Pagy::Frontend

  def markdown(text)

    return "" if text.blank?  # Ajouter cette ligne

    renderer = Redcarpet::Render::HTML.new(hard_wrap: true)
    markdown = Redcarpet::Markdown.new(renderer, autolink: true, tables: true)
    markdown.render(text).html_safe


  end

end
