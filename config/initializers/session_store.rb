# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_budgit_session',
  :secret      => '7bdb2e3fba8f9ff8774037e881ae2ffe861d2058e8fcb02a59b022e31c8e6eb4d70fe97d3dec2138d98b33a27b266d1ff061bcc0a9a157e96d7143f20f65500b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
