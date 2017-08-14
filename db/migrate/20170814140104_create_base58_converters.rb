class PrivateKeyGenerators < ActiveRecord::Migration[5.1]
  def change
    create_table :private_key_generators do |t|
      t.string :address
      t.string :private_key

      t.timestamps
    end
  end
end
