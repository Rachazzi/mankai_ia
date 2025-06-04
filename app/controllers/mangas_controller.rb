class MangasController < ApplicationController

  def index
    @mangas = Manga.all

  end

    def show
      @manga = Manga.find(params[:id])

    end

    def create
      @manga = Manga.new(manga_params)
      if @manga.save
        redirect_to manga_path(manga),
        notice: "Manga crée!"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      @manga = Manga.find(params[:id])
      @manga.destroy
      head :no_content
    end

    private

    def manga_params
      params.require(:manga).permit(:title, :overview, :author)
    end

end
