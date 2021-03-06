class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :setup_cart
  before_action :admin_only, except: [:index, :show, :autocomplete_product_name]

  autocomplete :product, :name
  autocomplete :product, :code

  def new
    @product = Product.default_product
  end

  def index
    @products = Product.all
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Bajo stock"   # Excluding ".pdf" extension.
      end
    end
  end

  def show
    @product = Product.find params[:id]

  end

  def create
    @product = Product.default_product

    FillProductService.new(@product, current_office, params).call

    if @product.save
      redirect_to @product
    else
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])

    UpdateHistoricPricesService.new(@product, params).call
    FillProductService.new(@product, current_office, params).call

    if @product.save
      redirect_to @product
    else
      Product.default_product(@product)
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to root_path, notice: 'Producto eliminado correctamente'
  end
end
