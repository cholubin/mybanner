migration 1, :address do
  up do
    create_table :addresses do        
      column :id, Integer, :serial => true, :nullable? => false
      column :zipcode, String, :nullable? => false
      column :city, String
      column :si_goon_goo, String
      column :dong, String
      column :building, String      
      column :address, String, :nullable? => false, :unique? => true     
    end
  end

  
  down do
    drop_table :addresses
  end
end
