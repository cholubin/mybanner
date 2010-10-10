migration 1, :checkout do
  up do
    create_table :checkouts do
      column :state, String, :nullable? => false      
      column :total_price, Float, :nullable? => false
      column :pay_method, String, :nullable? => false
      column :name, String, :nullable? => false 
      column :number, String, :nullable? => false     
      column :package_reciever, String
      column :phone, String
      column :delivery_method, String
      column :zipcode, String
      column :address, String
      column :detail_address, String      
      column :created_at, DateTime
      column :updated_at, DateTime
    end
  end

  down do
    drop_table :checkouts
  end
end
