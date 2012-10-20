class Simulacao < ActiveRecord::Base
	include ActionView::Helpers::NumberHelper

  attr_accessible :base, :margem_lucro,  :total_despesas, :despesas_attributes,
   :total_receitas, :despesas_fixas
   
   has_many :despesas
   accepts_nested_attributes_for :despesas, :allow_destroy => true
   
end
