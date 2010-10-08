class CreateMycarts < ActiveRecord::Migration
  def self.up
    create_table :mycarts do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :mycarts
  end
end
