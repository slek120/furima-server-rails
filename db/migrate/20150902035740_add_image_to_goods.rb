class AddImageToGoods < ActiveRecord::Migration
  def change
    create_table :good_images do |t|
      t.references :good, index: true, foreign_key: true
      t.string :image
      t.integer :index
      t.timestamps null: false
    end
  end
end
