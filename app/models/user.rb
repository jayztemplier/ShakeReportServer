class User
  include Mongoid::Document
  field :provider, type: String
  field :uid, type: String
  field :name, type: String
  field :email, type: String
  field :is_super_admin, type: Boolean

  def self.from_omniauth(auth)
    where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["nickname"]
      #user.email = auth["info"]["email"]
    end
  end

  def application_ids
    @application_ids ||= ApplicationAccess.where(user_id: self.id).map(&:application_id)
  end

  def applications
    @applications ||= Application.in(id: application_ids)
  end

  def is_admin?(application)
    access = ApplicationAccess.find_by(user_id: self.id, application_id: application.id)
    (!access.nil? && access.role == ApplicationAccess::ROLE[:admin])
  end
end
