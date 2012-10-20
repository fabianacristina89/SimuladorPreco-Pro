class AddSimulacaoIdToDespesa < ActiveRecord::Migration
  def change
    add_column :despesas, :simulacao_id, :integer
  end
end
