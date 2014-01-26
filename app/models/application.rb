class Application
  include Mongoid::Document
  field :name, type: String
  field :token, type: String
  embeds_many :reports

  before_create :generate_token

  protected

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token if Application.where(token: random_token).empty?
    end
  end
end
