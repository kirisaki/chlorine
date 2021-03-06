class CreateTables < ActiveRecord::Migration[6.1]
  def change
    drop_table :mounts, force: true, if_exists: true
    drop_table :volumes, force: true, if_exists: true
    drop_table :containers, force: true, if_exists: true
    drop_table :images, force: true, if_exists: true
    drop_table :magicklinks, force: true, if_exists: true
    drop_table :users, force: true, if_exists: true
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
      t.text :name
      t.text :id_on_docker
      t.text :filename
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    create_table :containers, force: true do |t|
      t.text :id_on_docker
      t.text :subdomain
      t.references :image, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

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
