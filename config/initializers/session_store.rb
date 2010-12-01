# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_kr_address_rails_cap_session_#{Rails.root}',
  :secret      => 'de88c6c1537a4f5e7d8853a62fa39e7451ae0147f7b14db3cdce7b02eae3a5c1c80a8f3edb517c1004ca4d20390adc2b7fe4c383221550f47a9e17e7012eee61'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

# ActionController::Base.session_store = :data_mapper_store