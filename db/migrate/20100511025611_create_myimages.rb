class CreateMyimages < ActiveRecord::Migration
  def self.up
    create_table :myimages do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :myimages
  end
end
