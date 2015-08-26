class CreateGoods < ActiveRecord::Migration
  def change
    create_table :goods do |t|
      t.string :title
      t.string :body
      t.decimal :price
      t.timestamps null: false
      t.datetime :expired_at
    end
  end
end
