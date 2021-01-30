class CreateContainers < ActiveRecord::Migration[6.1]
  def change
    create_table :containers do |t|
      t.references :image, null: false, foreign_key: true

      t.timestamps
    end
  end
end
