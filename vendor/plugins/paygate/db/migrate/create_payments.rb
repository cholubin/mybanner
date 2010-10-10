migration 1, :payment do
  up do
    create_table :payments do
      column :total_price, Float, :nullable? => false
      column :pay_method, String, :nullable? => false
      column :name, String, :nullable? => false
      column :created_at, DateTime
      column :updated_at, DateTime
    end
  end

  down do
    drop_table :payments
  end
end
