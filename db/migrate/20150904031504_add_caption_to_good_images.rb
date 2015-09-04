class AddCaptionToGoodImages < ActiveRecord::Migration
  def change
    add_column :good_images, :caption, :string
  end
end
