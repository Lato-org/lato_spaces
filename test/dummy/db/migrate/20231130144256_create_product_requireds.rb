class CreateProductRequireds < ActiveRecord::Migration[7.1]
  def change
    create_table :product_requireds do |t|

      t.timestamps
    end
  end
end
