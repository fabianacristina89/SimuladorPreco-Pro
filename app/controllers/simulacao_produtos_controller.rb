class SimulacaoProdutosController < ApplicationController
     
     include ActionView::Helpers::NumberHelper

     require 'yaml'
     caches_action :listar_produtos_vpsa
     URL_SERVICO_PRODUTOS = "https://www.vpsa.com.br/apps/api/produtos"

  def token
    session[:usuario][:access_token]
  end
  def cnpj_empresa
    session[:usuario][:cnpj_empresa]
  end
  def url_cache
    'cache.ProdutoVpsa'<<cnpj_empresa
  end
  def pagina_sessao
    session[:pagina_simulacao].to_i
  end
  def pagina_definida?
    pagina_sessao != 0 and pagina_sessao != nil
  end
 
  def atualizar_produtos_do_servico()
    
    ultimo_resultado_size = 50
    pagina = 1.to_f
    todos_itens  = listar_produtos_do_servico_por_pagina(pagina)
      
    begin
      pagina = pagina.to_f + 1
      lista_da_pagina = listar_produtos_do_servico_por_pagina(pagina)
      ultimo_resultado_size = lista_da_pagina.size
      todos_itens.concat lista_da_pagina
      copiar_para_produtos_vpsa(lista_da_pagina)
    end while ultimo_resultado_size == 50;   
    
  end
  def copiar_para_produtos_vpsa(todos_itens)
    todos_itens.each do |produto_vpsa_do_servico|
      produto_vpsa = VpsaProduto.find_or_create_by_documento_base_and_id_produto_vpsa(cnpj_empresa,  produto_vpsa_do_servico["id"].to_f )
      produto_vpsa.id_produto_vpsa = produto_vpsa_do_servico["id"].to_f
      produto_vpsa.descricao = produto_vpsa_do_servico["descricao"]
      produto_vpsa.preco = produto_vpsa_do_servico["preco"].to_f
      produto_vpsa.documento_base = cnpj_empresa;
      produto_vpsa.save
    end
  end
  def listar_produtos_sem_cache()
    if !pagina_definida?
      session[:pagina_simulacao] = 1
    end
    pagInicial = session[:pagina_simulacao].to_f;
    VpsaProduto.where(:documento_base=>cnpj_empresa).paginate(:page => pagInicial, :per_page => 50).order('descricao asc')
  end
  def listar_produtos_do_servico_por_pagina(pagina)
    pagInicial = pagina.to_f;
    inicio = pagInicial*50
      
      parametros = {
        :token => token,
        :inicio => inicio.to_i,
        :quantidade => 50
      }
      HTTParty.get(URL_SERVICO_PRODUTOS + '?'+ parametros.to_query) 
    #Array.new
  end

  def definir_pagina(incremento)
    pagina_definida = session[:pagina_simulacao].to_f;
    pagina_definida = pagina_definida + incremento;
    session[:pagina_simulacao] = pagina_definida
  end
  
  def proxima_pagina
    definir_pagina(1)
    redirect_to :controller=>'simulacao_produtos', :action => 'index'
  end

  def pagina_anterior
    definir_pagina(-1)
    redirect_to :controller=>'simulacao_produtos', :action => 'index'
  end

  def listar_simulacao_produto(produtos, simulacao)
    SimulacaoProduto.find_all_by_simulacao_id(simulacao);
  end
 # GET /simulacao_produtos
  # GET /simulacao_produtos.json
  def index
    if !pagina_definida? or pagina_sessao == 1
      Thread.new{atualizar_produtos_do_servico()}
    end

    @simulacao  = Simulacao.find_or_create_by_base(cnpj_empresa)
    @lista_final = Array.new
    @produtos = Array.new
    @produtos = listar_produtos_sem_cache();
    @pagina_atual = pagina_sessao.to_s

    
    todos = listar_simulacao_produto(@produtos, @simulacao)

     @produtos.each do |produto|
          encontrou = false;
          prod = SimulacaoProduto.new
          prod.descricao = produto["descricao"]
          prod.produto_vpsa_id = produto.id_produto_vpsa
          prod.preco_vpsa =  number_to_currency(produto["preco"], :unit => "", :separator => ",", :delimiter => ".")
         
      
           todos.each do |simulacao|
        
               if simulacao.produto_vpsa_id == produto["id"] then
                   @encontrou = true
                 
                   
                   prod.ipi = simulacao.ipi
                   prod.icms = simulacao.icms
                   prod.outros_impostos = simulacao.outros_impostos
                   prod.comissao = simulacao.comissao
                   prod.frete= simulacao.frete
                   prod.outros_custos = simulacao.outros_custos
                   prod.preco_compra = simulacao.preco_compra
                   
                   prod.preco_calculado = calcular_preco(prod, @simulacao)
                   
                   

               end
        
          end
      prod.existe = encontrou
      @lista_final << prod
      
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @simulacao_produtos }
    end
  end
  def calcular_preco (simulacao_produto, simulacao)
      markup =  100 - 
                   (simulacao_produto.icms.to_f + simulacao_produto.ipi.to_f + simulacao_produto.outros_impostos.to_f + simulacao_produto.frete.to_f + 
                   simulacao_produto.comissao.to_f + simulacao_produto.outros_custos.to_f + simulacao.despesas_fixas.to_f + simulacao.margem_lucro.to_f)
      number_to_currency(simulacao_produto.preco_compra.to_f / (markup / 100), :unit => "", :separator => ",", :delimiter => ".") 

  end
  def atualizar_valor
     @produtos.each do |produto|
        prod.preco_calculado = calcular_preco(prod, @simulacao)
    end
  end
  # GET /simulacao_produtos/1
  # GET /simulacao_produtos/1.json
  def show
    @simulacao_produto = SimulacaoProduto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @simulacao_produto }
    end
  end

  # GET /simulacao_produtos/new
  # GET /simulacao_produtos/new.json
  def new
    @simulacao_produto = SimulacaoProduto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @simulacao_produto }
    end
  end



  # GET /simulacao_produtos/1/edit
  def edit
    @simulacao_produto = SimulacaoProduto.find(params[:id])
  end

  # POST /simulacao_produtos
  # POST /simulacao_produtos.json
  def create
    
    prod = params[:simulacao_produto];
  
    @simulacao_produto = SimulacaoProduto.new(prod)
    @simulacao_produto.simulacao = Simulacao.find_or_create_by_base(cnpj_empresa)
    
    respond_to do |format|
      if @simulacao_produto.save
        format.html { redirect_to @simulacao_produto, notice: 'Simulacao produto was successfully created.' }
        format.json { render json: @simulacao_produto, status: :created, location: @simulacao_produto }
        #atualizar_valor
      else
        format.html { render action: "new" }
        format.json { render json: @simulacao_produto.errors, status: :unprocessable_entity }
      end
    end
  end

  
  # PUT /simulacao_produtos/1
  # PUT /simulacao_produtos/1.json
  def update
    @simulacao_produto = SimulacaoProduto.find(params[:id])
    
    respond_to do |format|
      if @simulacao_produto.update_attributes(params[:simulacao_produto])
        format.html { redirect_to @simulacao_produto, notice: 'Simulacao produto was successfully updated.' }
        format.json { head :no_content }
        #atualizar_valor
      else
        format.html { render action: "edit" }
        format.json { render json: @simulacao_produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /simulacao_produtos/1
  # DELETE /simulacao_produtos/1.json
  def destroy
    @simulacao_produto = SimulacaoProduto.find(params[:id])
    @simulacao_produto.destroy

    respond_to do |format|
      format.html { redirect_to simulacao_produtos_url }
      format.json { head :no_content }
    end
  end
end