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
  @chat = Chat.find(params[:id])
  @message = Message.new
  end

  def create
    @chat = Chat.new(title: "New chat", model_id: "gpt-4o-mini") # ou le modèle que vous voulez utiliser

    if params[:manga_id].present?
      @manga = Manga.find_by(id: params[:manga_id])
      @chat.manga = @manga if @manga
    end

    @chat.user = current_user

    if @chat.save
      redirect_to chat_path(@chat)
    else
      prepare_index_variables
      render :index
    end
  end

  private

  def prepare_index_variables
    if params[:manga_id]
      @manga = Manga.find_by(id: params[:manga_id])
      @chats = current_user.chats.where(manga: @manga)
    else
      @chats = current_user.chats.where(manga: nil)
    end
  end
end
