class CreateVolumes < ActiveRecord::Migration[6.1]
  def change
    create_table :volumes do |t|
      t.string :name
      t.string :docker_name
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
