class Despesa < ActiveRecord::Base
  attr_accessible :base, :nome, :tipo, :valor, :simulacao_id
  belongs_to :simulacao
end
