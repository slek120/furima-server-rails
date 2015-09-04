class GoodsController < ApplicationController
  before_action :set_good, only: [:show, :edit, :update, :destroy]

  def index
    @goods = Good.all
  end

  def new
  end

  def create
    @good = current_user.goods.create(good_params)
    @good.good_images << GoodImage.create(image_params)
    redirect_to goods_path, notice: 'Successfully created'
  end

  def edit
  end

  def update
    if @good.update_attributes(good_params)
      redirect_to good_path(good), notice: 'Successfully updated'
    else
      redirect_to :back, notice: 'Could not update'
    end 
  end

  def show
  end

  def destroy
    @good.destroy
    redirect_to goods_path
  end

  private

  def set_good
    @good = Good.find(params[:id])
  end

  def image_params
    params.require(:good_image).permit(:image)
  end
end
