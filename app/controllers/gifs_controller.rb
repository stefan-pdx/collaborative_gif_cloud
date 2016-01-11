class GifsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_gif, only: [:show, :edit, :update, :destroy]

  def index
    @gifs = GIF.search(query).page(page).records
  end

  def show
  end

  def new
    @gif = GIF.new
  end

  def edit
  end

  def create
    @gif = GIF.new(gif_params)

    respond_to do |format|
      if @gif.save
        format.html { redirect_to @gif, notice: 'GIF was successfully created.' }
        format.json { render :show, status: :created, location: @gif }
      else
        format.html { render :new }
        format.json { render json: @gif.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @gif.update(gif_params)
        format.html { redirect_to @gif, notice: 'GIF was successfully updated.' }
        format.json { render :show, status: :ok, location: @gif }
      else
        format.html { render :edit }
        format.json { render json: @gif.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @gif.destroy
    respond_to do |format|
      format.html { redirect_to gifs_url, notice: 'GIF was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_gif
    @gif = GIF.find(params[:id])
  end

  def gif_params
    params.
      require(:gif).
      permit(:description, :metadata, :image, :tag_list, :title).
      merge(user_id: current_user.id).
      merge(metadata: JSON.parse(params[:gif][:metadata]))
  end

  def query
    params[:q] || '*'
  end

  def page
    params[:page] || 1
  end
end
