class ApplicationAccess
  include Mongoid::Document

  ROLE = {user: 0, admin: 1 }

  field :application_id, type: String
  field :user_id, type: String
  field :role, type: Integer, default: ROLE[:user]

end
