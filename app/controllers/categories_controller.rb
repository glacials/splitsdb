class CategoriesController < ApplicationController

  # GET /games/:game_id/categories
  # GET /games/:game_id/categories.json
  def index
    @categories = @game.categories
  end

  # GET /games/:game_id/categories/:category_id
  # GET /games/:game_id/categories/:category_id.json
  def show
    @category = Category.find(params[:id])
    @game = Game.friendly.find(params[:game_id])
  end

  # GET /games/:game_id/categories/new
  # GET /games/:game_id/categories/new.json
  def new
    @category = Category.new
    @game = Game.friendly.find(params[:game_id])
  end

  # POST /games/:game_id/categories/create
  # POST /games/:game_id/categories/create.json
  def create
    @game = Game.friendly.find(params[:game_id])
    @category = @game.categories.create(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to game_category_path(@game, @category), notice: 'Category created.' }
        format.json { render action: 'show', status: :created, location: @category }
      else
        format.html { render action: 'new' }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
      @game = Game.friendly.find(params[:game_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name, :description)
    end
end
