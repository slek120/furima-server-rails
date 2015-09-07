class GoodsController < ApplicationController
  before_action :set_good, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @goods = Good.includes(:good_images, :user)
  end

  def new
    @good = current_user.goods.new
    @image = @good.good_images.build
  end

  def create
    @good = current_user.goods.new(good_params)
    if @good.save
      params[:good_image]['image'].each do |img|
        @good_image = @good.good_images.create!(image: img)
      end
      redirect_to edit_good_path(@good)
    else
      redirect_to goods_path, alert: 'There was a problem'
    end
  end

  def edit
  end

  def update
    if @good.update_attributes(good_params)
      redirect_to good_path(good), notice: 'Successfully updated'
    else
      redirect_to :back, alert: 'Could not update'
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

  def good_params
    params.require(:good).permit(:title, :body, :price, :expired_at, good_image_attributes: [:id, :good_id, :image, :index])
  end
end
