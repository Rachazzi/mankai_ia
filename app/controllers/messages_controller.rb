class MessagesController < ApplicationController
  def index
    @messages = Message.all

  end


  def new
    @message = Message.new
  end

  SYSTEM_PROMPT = "You are a Manga Specialist.\n

  \nI am a manga fan, and i looking for infos of mangas.\n
  \nHelp me to discover new mangas, give me 3 titles of mangas, with a little overview.\n
  \nAnswer concisely in markdown."

  def create
    @manga = Manga.create()
    @message = Message.new(role: "user", content: params[:message][:content], manga: @manga)
    if @message.save
      @chat = RubyLLM.chat
      response = @chat.with_instructions(SYSTEM_PROMPT).ask(@message.content)
      Message.create(role: "assistant", content: response.content, manga: @manga)
      redirect_to messages_path()
    else
      render :new
    end
  end

private

  def manga_context
    "Here is the context of the manga: #{@manga.content}."
  end

  def instructions
    [SYSTEM_PROMPT, manga_context].compact.join("\n\n")
  end
end
