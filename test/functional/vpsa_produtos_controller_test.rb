require 'test_helper'

class VpsaProdutosControllerTest < ActionController::TestCase
  setup do
    @vpsa_produto = vpsa_produtos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vpsa_produtos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vpsa_produto" do
    assert_difference('VpsaProduto.count') do
      post :create, vpsa_produto: { descricao: @vpsa_produto.descricao, id: @vpsa_produto.id, preco: @vpsa_produto.preco }
    end

    assert_redirected_to vpsa_produto_path(assigns(:vpsa_produto))
  end

  test "should show vpsa_produto" do
    get :show, id: @vpsa_produto
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vpsa_produto
    assert_response :success
  end

  test "should update vpsa_produto" do
    put :update, id: @vpsa_produto, vpsa_produto: { descricao: @vpsa_produto.descricao, id: @vpsa_produto.id, preco: @vpsa_produto.preco }
    assert_redirected_to vpsa_produto_path(assigns(:vpsa_produto))
  end

  test "should destroy vpsa_produto" do
    assert_difference('VpsaProduto.count', -1) do
      delete :destroy, id: @vpsa_produto
    end

    assert_redirected_to vpsa_produtos_path
  end
end
