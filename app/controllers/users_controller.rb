class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    if user_params[:action] == 'signup'
      @user = User.create(user_params.except(:action))
      @session = UserSession.create(:email => user_params[:email], :password => user_params[:password], :remember_me => true)
      respond_to do |format|
        if @user.save
          format.html { redirect_to '/', notice: 'Account created! Welcome, ' + @user.name + '.' }
          format.json { render action: 'show', status: :created, location: @user }
        else
          format.html { redirect_to action: 'new' }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      @session = UserSession.create(:email => user_params[:email], :password => user_params[:password], :remember_me => true)
      respond_to do |format|
        if @session.save
          format.html { redirect_to root_path, notice: "Welcome, #{current_user.name}. You're logged in!" }
          format.json { render action: 'show', location: current_user }
        else
          format.html { redirect_to login_path, alert: 'Incorrect email or password.' }
          format.json { render json: current_user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:action, :email, :name, :password, :password_confirmation)
    end
end
