class ChatsController < ApplicationController
  def index
    if params[:manga_id]
      @manga = Manga.find_by(id: params[:manga_id])
      @chats = current_user.chats.where(manga: @manga)
    else
      @chats = current_user.chats.where(manga: nil)
    end
    @chat = Chat.new
  end

  def new
    @chat = Chat.new
  end

  def show
    # Récupére l'id du chat passé dans l'URL
    @chat = Chat.find(params[:id])
    # Ordonne les messages en ordre croissant en fonction de leur création
    @messages = @chat.messages.order(:created_at)
    # Permet de d'instancié un nouveau message
    @message = Message.new
  end

  def create
    @chat = Chat.new(title: "Untitled")
    @chat.user = current_user

    @chat.manga = Manga.find_by(id: params[:manga_id]) if params[:manga_id]

    if @chat.save
      redirect_to chat_path(@chat)
    else
      render :index, status: :unprocessable_entity
    end
  end
end
