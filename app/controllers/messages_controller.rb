class MessagesController < ApplicationController
  def index
    @messages = Message.all

  end


  def new
    @message = Message.new
  end

  SYSTEM_PROMPT = <<~PROMPT
  Tu es un spécialiste des mangas.

  Je suis un fan de manga novice, et je cherche à découvrir de nouveaux mangas.
  Pour m'aider à découvrir de nouveaux ouvrages, présente-moi 3 mangas sous le format suivant, en Markdown :

  1. **Titre** : _Nom du manga_
     **Genre** : _Action / Fantastique / Autre_
     **Description** : Une courte description ici.

  2. **Titre** : _..._
     **Genre** : _..._
     **Description** : _..._

  3. **Titre** : _..._
     **Genre** : _..._
     **Description** : _..._

   La réponse doit être formatée en **Markdown**.
PROMPT

  def create
    @manga = Manga.create()
    @message = Message.new(role: "user", content: params[:message][:content], manga: @manga)

    if @message.save
      @chat = RubyLLM.chat
      response = @chat.with_instructions(SYSTEM_PROMPT).ask(@message.content)

      @message.update(response: response.content)

      redirect_to message_path(@message)
    else
      render :new
    end
  end


  def show
    @message = Message.find(params[:id])
  end

private

  def manga_context
    "Here is the context of the manga: #{@manga.content}."
  end

  def instructions
    [SYSTEM_PROMPT, manga_context].compact.join("\n\n")
  end
end
