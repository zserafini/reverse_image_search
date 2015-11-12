class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.column :p_hash, 'bigint unsigned'
      t.string :path
      t.timestamps
    end
  end
end
