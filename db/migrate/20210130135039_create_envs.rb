class CreateEnvs < ActiveRecord::Migration[6.1]
  def change
    create_table :envs do |t|
      t.text :name
      t.text :value
      t.references :container, null: false, foreign_key: true

      t.timestamps
    end
  end
end
