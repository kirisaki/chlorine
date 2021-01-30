class CreateMagicklinks < ActiveRecord::Migration[6.1]
  def change
    create_table :magicklinks do |t|
      t.text :mail
      t.text :token

      t.timestamps
    end
  end
end
