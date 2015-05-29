class RemoveImageUrlFromProduct < ActiveRecord::Migration
  def up
    remove_column :products, :image_url, :string
  end

  def down
    add_column :products, :image_url, :string
  end
end
