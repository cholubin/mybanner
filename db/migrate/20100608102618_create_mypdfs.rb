class CreateMypdfs < ActiveRecord::Migration
  def self.up
    create_table :mypdfs do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :mypdfs
  end
end
