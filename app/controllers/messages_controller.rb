class MessagesController < ApplicationController
  def index
    @messages = Message.all
  end
  def new
    @message = Message.new
  end

  SYSTEM_PROMPT = <<~PROMPT
    Tu es un spécialiste des mangas.
    Tu réponds aux questions d'un fan de manga novice.
    Pour aider l'utilisateur à découvrir de nouveaux ouvrages, présente-lui 2 à 3 manga adapté à son profil.
    Si l'utilisateur pose une question précise sur un manga, donne-lui une description personnalisée et adaptée à sa demande.
    Donne lui des informations clair et pertinantes et réponds toujours en français.
  PROMPT

  def create
    @chat = Chat.find(params[:chat_id])
    @manga = @chat.manga  # Décommentez cette ligne
    @message = Message.new(message_params.merge(role: "user", chat: @chat))
    if @message.valid? # don't call `save` anymore
      @chat.with_tool(MangaFinderTool).with_instructions(instructions).ask(@message.content)
      if @chat.title == "Untitled"
        @chat.generate_title_from_first_message
      end
      redirect_to chat_path(@chat)
    end
  end

  def show
    @message = Message.find(params[:id])
  end

private
  def message_params
    params.require(:message).permit(:content)
  end

  def manga_context
    return nil unless @manga
    "Here is the context of the manga: #{@manga.content}."
  end

  def instructions
    [SYSTEM_PROMPT, manga_context].compact.join("\n\n")
  end

  def build_conversation_history
  model = @chat.model_id || "gpt-4o-mini" # valeur par défaut
  @ruby_llm_chat = RubyLLM.chat(model: model)
  @chat.messages.each do |message|
    @ruby_llm_chat.add_message(message)
    end
  end
end
