class CreateMounts < ActiveRecord::Migration[6.1]
  def change
    create_table :mounts do |t|
      t.text :path
      t.references :volume, null: false, foreign_key: true
      t.references :container, null: false, foreign_key: true

      t.timestamps
    end
  end
end
