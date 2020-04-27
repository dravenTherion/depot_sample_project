class LineItemsController < ApplicationController

  include CurrentCart
  before_action :set_cart, only: [:create]
  #before_action :invalid_owner, only: [:show, :edit, :update, :destroy]
  before_action :get_cart, only: [:show, :edit, :update, :destroy]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_product_access

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
    #redirect direct access to product from link_items
    :invalid_product_access
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product)
    
    session[:counter] = nil;

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_index_url}#@line_item.cart}
        format.js { @current_item = @line_item }
        format.json { render :show,
          status: :created, location: @line_item }
      else
        format.html { render :new }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy

    @quantity = 0;

    # if item quantity is greater than 1, decrease it by 1
    if(@line_item.quantity > 1)
      @line_item.quantity -= 1
      @line_item.save

      @quantity = @line_item.quantity.to_s;
    # otherwise delete it  
    else
      @line_item.destroy
    end

    respond_to do |format|

      format.html { redirect_to store_index_url, notice: 'Item was successfully removed from your cart.' }
      format.js { @invert = true, @current_item = @line_item }
      format.json { head :no_content }
    
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def line_item_params
      params.require(:line_item).permit(:product_id)
    end

end