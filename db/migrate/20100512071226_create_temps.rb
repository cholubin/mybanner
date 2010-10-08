class CreateTemps < ActiveRecord::Migration
  def self.up
    create_table :temps do |t|
      t.string :title
      t.string :file

      t.timestamps
    end
  end

  def self.down
    drop_table :temps
  end
end
