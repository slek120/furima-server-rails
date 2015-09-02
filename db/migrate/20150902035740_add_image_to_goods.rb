class AddImageToGoods < ActiveRecord::Migration
  def change
    create_table :good_images do |t|
      t.belongs_to :good, index: true
      t.string :image
      t.integer :index
      t.timestamps null: false
    end
  end
end
