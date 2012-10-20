class CreateVpsaProdutos < ActiveRecord::Migration
  def change
    create_table :vpsa_produtos do |t|
      t.integer :id_produto_vpsa
      t.string :descricao
      t.decimal :preco
      t.string :documento_base
      t.timestamps
    end
  end
end
