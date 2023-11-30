class CreateProductUniques < ActiveRecord::Migration[7.1]
  def change
    create_table :product_uniques do |t|

      t.timestamps
    end
  end
end
