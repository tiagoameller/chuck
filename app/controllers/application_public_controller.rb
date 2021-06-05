# rubocop:disable Rails/ApplicationController
class ApplicationPublicController < ActionController::Base
  # can be reproduced as
  # curl -X POST "http://localhost:3000/public/customer_documents/05dcf2f6-8376-425a-858c-8cc362736498/download_signed_document" > ~/Downloads/q.pdf
  # if user remembers POST from an expired session
  protect_from_forgery with: :reset_session
end
# rubocop:enable Rails/ApplicationController
