class RunsController < ApplicationController
  before_action :set_run, only: [:show, :edit, :update, :destroy]

  def download_exact
    set_run
    wsplit_file = 'Title=' + @run.title + "\n"
    wsplit_file += 'Attempts=' + @run.attempts.to_s + "\n"
    wsplit_file += 'Offset=' + @run.offset.to_s + "\n"
    wsplit_file += 'Size=' + @run.size + "\n"
    icons_string = 'Icons='
    @run.splits.each do |split|
      wsplit_file += split.name + ',0,' + split.best_run_seconds.to_s + ',' + split.best_segment_seconds.to_s + "\n"
      icons_string += '"",'
    end
    wsplit_file += icons_string[0..-2]
    filename = @run.user.name.downcase + '-' + @game.name.downcase + '-' + @category.name.downcase + '.wsplit'
    filename.gsub!(' ', '-')
    headers['Content-Disposition'] = 'attachment; filename="' + filename + '"'
    render text: wsplit_file
  end

  def download_blank
    # todo: see what a blank splits file looks like
  end

  def compare
    @game = Game.friendly.find(params[:game_id])
    @category = Category.find(params[:category_id])
    @run = Run.find(params[:id])
    compare = Run.find(params[:compare_id])
    redirect_to compare_path(@game, @category, @run, compare), notice: 'Comparing complete. See below.'
  end

  # GET /runs
  # GET /runs.json
  def index
    @game = Game.friendly.find(params[:game_id])
    @category = Category.find(params[:category_id])
    if @category.game != @game
      redirect_to @game, alert: 'Invalid game/category pairing.'
    end
    @runs = @category.runs
    render 'categories/show'
  end

  # GET /runs/1
  # GET /runs/1.json
  def show
    @game = Game.friendly.find(params[:game_id])
    @category = Category.find(params[:category_id])
    if params[:compare_id].present?
      @compare = Run.find(params[:compare_id])
    end
    if @compare.present? && @run.splits.count != @compare.splits.count
      redirect_to game_category_run_path(@game, @category, @run), alert: "You can't compare runs unless they have the same number of splits."
    end
  end

  # GET /runs/new
  def new
    @run = Run.new
    if params[:game_id].present? and params[:category_id].present?
      @game = Game.friendly.find(params[:game_id])
      @category = Category.find(params[:category_id])
      if @category.game != @game
        redirect_to upload_path, alert: 'The given game/category combination was invalid.'
      end
    end
  end

  # GET /runs/1/edit
  def edit
    @run = Run.find(params[:id])
    if params[:game_id].present?
      @game = Game.find(params[:game_id])
    end
    if params[:category_id]
      @category = Category.find(params[:category_id])
      if @run.user == current_user
        @run.category = @category
        @run.save
        redirect_to '/games/' + @game.id.to_s + '/categories/' + @category.id.to_s + '/runs/' + @run.id.to_s, notice: 'Run saved.'
      end
    end
  end

  # POST /runs
  # POST /runs.json
  def create
    @category = Category.find(params[:category_id])
    @run = @category.runs.new()
    @run.category = @category
    @run.user = current_user
    params[:run][:file].read.each_line do |line|
      if line.start_with?('Title=')
        @run.title = line.sub('Title=', '')
      elsif line.start_with?('Attempts=')
        @run.attempts = line.sub('Attempts=', '').chomp
      elsif line.start_with?('Offset=')
        @run.offset = line.sub('Offset=', '').chomp
      elsif line.start_with?('Size=')
        @run.size = line.sub('Size=', '').chomp
      elsif line.start_with?('Icons=')
        # nothing to do
      else
        split = @run.splits.new()
        s = line.split(',')
        split.name = s[0]
        split.old = s[1].to_i
        split.best_run = s[2].to_i
        split.best_segment = s[3].to_i
      end
    end
    respond_to do |format|
      if @run.save
        format.html { redirect_to game_category_run_path(@run.game, @run.category, @run), notice: 'Run created.' }
        format.json { render action: 'show', status: :created, location: @run }
      else
        format.html { render action: 'new' }
        format.json { render json: @run.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /runs/1
  # PATCH/PUT /runs/1.json
  def update
    if run_params[:game]
      redirect_to '/games/' + Game.find_by_name(run_params[:game]).id.to_s + '/runs/' + @run.id.to_s + '/edit/'
    else
      respond_to do |format|
        if @run.update(run_params)
          format.html { redirect_to edit_run_path(@run) }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @run.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /runs/1
  # DELETE /runs/1.json
  def destroy
    if current_user == @run.user
      @run.destroy
      respond_to do |format|
        format.html { redirect_to game_category_path(@game, @category), notice: 'Run deleted.' }
        format.json { head :no_content }
      end
    else
      redirect_to game_category_run_path(@game, @category, @run), alert: 'You don\'t own that run.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_run
      @run = Run.find(params[:id])
      @category = @run.category
      @game = @category.game
      if @game != Game.friendly.find(params[:game_id])
        redirect_to game_path( Game.friendly.find(params[:game_id]) ), alert: 'Bad URL.'
      end
      if @category != Category.find(params[:category_id])
        redirect_to game_category_path( Category.find(params[:category_id]) ), alert: 'Bad URL.'
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def run_params
      params.require(:run).permit(:game, :category)
    end
end
