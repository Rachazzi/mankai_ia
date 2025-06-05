class ChatsController < ApplicationController
  def index
    # Récupère le manga correspondant à l'id passé dans l'URL
    @manga = Manga.find(params[:manga_id])
    # Récupère tous les chats de l'utilisateur liés à ce manga
    @chats = current_user.chats.where(manga: @manga)
  end

  def show
    # Récupére l'id du chat passé dans l'URL
    @chat = Chat.find(params[:id])
    # Ordonne les messages en ordre croissant en fonction de leur création
    @messages = @chat.messages.order(:created_at)
    # Permet de d'instancié un nouveau message
    @message = Message.new
  end
end
