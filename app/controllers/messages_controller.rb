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
    @manga = @chat.manga
    @message = Message.new(message_params.merge(role: "user", chat: @chat, user: current_user))
    if @message.save
      build_conversation_history
      @response = @ruby_llm_chat.with_instructions(instructions).ask(@message.content)
      Message.create(role: "assistant", content: @response.content, chat: @chat)
      redirect_to chat_path(@chat)
    else
      @messages = @chat.messages.order(:created_at)
      render "chats/show", status: :unprocessable_entity
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

  def build_conversation_history
    @ruby_llm_chat = RubyLLM.chat
    @chat.messages.each do |message|
      @ruby_llm_chat.add_message(message)
    end
  end
end
