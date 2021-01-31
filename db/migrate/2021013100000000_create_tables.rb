class CreateTables < ActiveRecord::Migration[6.1]
  def change
    create_table :users, force: true do |t|
      t.string :name
      t.text :mail
      t.text :fingerprint
      t.text :token

      t.timestamps
    end
    create_table :magicklinks, force: true do |t|
      t.text :mail
      t.text :token

      t.timestamps
    end
    create_table :images, force: true do |t|
      t.text :filename
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    create_table :containers, force: true do |t|
      t.references :image, null: false, foreign_key: true

      t.timestamps
    end
    create_table :envs, force: true do |t|
      t.text :name
      t.text :value
      t.references :container, null: false, foreign_key: true

      t.timestamps
    end
    create_table :volumes, force: true do |t|
      t.string :name
      t.string :docker_name
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    create_table :mounts, force: true do |t|
      t.text :path
      t.references :volume, null: false, foreign_key: true
      t.references :container, null: false, foreign_key: true

      t.timestamps
    end
  end
end
