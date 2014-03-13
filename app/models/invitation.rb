class Invitation
  include Mongoid::Document
  include Mongoid::Timestamps

  before_create :before_create_hook
  after_create :after_create_hook

  field :email, type: String
  field :hash, type: String
  belongs_to :application
  validates :email, presence: true
  validates :hash, presence: true
  validates :application_id, presence: true

  def self.find_by_token(token)
    Invitation.find_by(hash: hash_for_token(token))
  end

  def before_create_hook
    generate_code
  end

  def after_create_hook
    InvitationMailer.new_invitation(self, @token).deliver
  end

  def use!(user)
    ApplicationAccess.create!(user_id: user.id, application_id: self.application_id)
  end

  private
  def generate_code
    @token = SecureRandom.base64(15).tr('+/=lIO0', 'pqrsxyz')
    self.hash = Invitation.hash_for_token(@token)
  end

  def self.hash_for_token(token)
    Digest::SHA1.hexdigest(token + "mysecretkeyis_severine---!!")
  end

end
