class VpsaProdutosController < ApplicationController
  # GET /vpsa_produtos
  # GET /vpsa_produtos.json
  def index
    @vpsa_produtos = VpsaProduto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @vpsa_produtos }
    end
  end

  # GET /vpsa_produtos/1
  # GET /vpsa_produtos/1.json
  def show
    @vpsa_produto = VpsaProduto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vpsa_produto }
    end
  end

  # GET /vpsa_produtos/new
  # GET /vpsa_produtos/new.json
  def new
    @vpsa_produto = VpsaProduto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vpsa_produto }
    end
  end

  # GET /vpsa_produtos/1/edit
  def edit
    @vpsa_produto = VpsaProduto.find(params[:id])
  end

  # POST /vpsa_produtos
  # POST /vpsa_produtos.json
  def create
    @vpsa_produto = VpsaProduto.new(params[:vpsa_produto])

    respond_to do |format|
      if @vpsa_produto.save
        format.html { redirect_to @vpsa_produto, notice: 'Vpsa produto was successfully created.' }
        format.json { render json: @vpsa_produto, status: :created, location: @vpsa_produto }
      else
        format.html { render action: "new" }
        format.json { render json: @vpsa_produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /vpsa_produtos/1
  # PUT /vpsa_produtos/1.json
  def update
    @vpsa_produto = VpsaProduto.find(params[:id])

    respond_to do |format|
      if @vpsa_produto.update_attributes(params[:vpsa_produto])
        format.html { redirect_to @vpsa_produto, notice: 'Vpsa produto was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @vpsa_produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vpsa_produtos/1
  # DELETE /vpsa_produtos/1.json
  def destroy
    @vpsa_produto = VpsaProduto.find(params[:id])
    @vpsa_produto.destroy

    respond_to do |format|
      format.html { redirect_to vpsa_produtos_url }
      format.json { head :no_content }
    end
  end
end
