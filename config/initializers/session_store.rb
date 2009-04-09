# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_rtemp_session',
  :secret      => 'c82ebfb5aebb510c1051be0dce1165c0b3d9f41e0988bc32bf2aafbf143c86c67cc2d097e9f9ee318141711a5cc37312fa2cb4b5891a07da2368dc05072f0ed2'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
