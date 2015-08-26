class GoodsController < ApplicationController
  def index
    @goods = Good.all
  end

  def new
  end

  def create
    @good = Good.create(good_params)
    redirect_to goods_path, notice: 'Successfully created'
  end

  def edit
    @good = Good.find(params[:id])
  end

  def update
    good = Good.find(params[:id])
    if good.update_attributes(good_params)
      redirect_to good_path(good), notice: 'Successfully updated'
    else
      redirect_to :back, notice: 'Could not update'
    end 
  end

  def show
    @good = Good.find(params[:id])
  end

  def destroy
    Good.destroy(params[:id])
    redirect_to goods_path
  end

  private

  def good_params
    params.require(:good).permit(:title, :body, :price, :expired_at)
  end
end
