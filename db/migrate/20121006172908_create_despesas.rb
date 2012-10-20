class CreateDespesas < ActiveRecord::Migration
  def change
    create_table :despesas do |t|
      t.string :base
      t.integer :tipo
      t.string :nome
      t.decimal :valor

      t.timestamps
    end
  end
end
