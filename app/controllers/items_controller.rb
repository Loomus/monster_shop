class ItemsController < ApplicationController
  def index
    if params[:merchant_id]
      @merchant = Merchant.find(params[:merchant_id])
      @items = @merchant.items
    else
      @items = Item.where({active: true})
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @item = @merchant.items.new(item_params)
    if @item.save
      redirect_to "/merchants/#{@merchant.id}/items"
    else
      generate_flash(@item)
      render :new
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to "/items/#{@item.id}"
    else
      generate_flash(@item)
      render :edit
    end
  end

  def destroy
    binding.pry
    item = Item.find(params[:id])
    if current_merchant_admin?
      if item.orders.empty?
        item.destroy
        flash[:notice] = "#{item.name} has been deleted."
      end
        redirect_to "/merchants/#{params[:merchant_id]}/items"
    else
      if
        item.orders.empty?
        item.destroy
      else
        flash[:notice] = "#{item.name} can not be deleted - it has been ordered!"
      end
      redirect_to '/items'
    end
  end




  #   if item.orders.empty?
  #     item.destroy
  #   else
  #     flash[:notice] = "#{item.name} can not be deleted - it has been ordered!"
  #   end
  #   redirect_to '/items'
  # end

  private

  def item_params
    params.permit(:name, :description, :price, :image, :inventory)
  end
end
