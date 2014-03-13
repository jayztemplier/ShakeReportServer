class ApplicationAccess
  include Mongoid::Document

  attr_accessor :username

  ROLE = {user: 0, admin: 1 }

  field :application_id, type: String
  field :user_id, type: String
  field :role, type: Integer, default: ROLE[:user]

  validate :does_not_already_exists, on: :create

  def user
    User.find(self.user_id)
  end


  protected
  def does_not_already_exists
    errors.add(:user_id, 'already has access to this application') if ApplicationAccess.where(user_id: user_id, application_id: application_id).exists?
  end

end
