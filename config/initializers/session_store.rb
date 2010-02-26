# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_bighelpmob_session',
  :secret => 'e98fd7a13653f9488440bff65ca5b03746748cc3fb9350b75b0966aec558b9570cf5baab912ce833a6c4917532aa54572c60c4eaaa4cfe2e3a1f77ec98d2eb8b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
