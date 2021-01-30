class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.text :mail
      t.text :fingerprint
      t.text :token

      t.timestamps
    end
  end
end
