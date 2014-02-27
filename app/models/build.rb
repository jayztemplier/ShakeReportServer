class Build
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  default_scope order_by(:created_at => :desc)
  before_create :before_create_hook
  after_create :after_create_hook

  field :title, type: String
  field :version, type: String

  has_mongoid_attached_file :ipa, path: "/#{Rails.env}/:class/:id/:filename"
  has_mongoid_attached_file :manifest, path: "/#{Rails.env}/:class/:id/manifest.plist"

  belongs_to :application

  def itunes_url
    if self.manifest
      "itms-services://?action=download-manifest&url=#{self.manifest.url}"
    else
      "#"
    end
  end

  def before_create_hook
    # do nothing yet, will initiate the email to send
    ipa_file = IpaReader::IpaFile.new(self.ipa.queued_for_write[:original].path)
    self.title = ipa_file.name + ' - v' + ipa_file.version
    generate_manifest!(ipa_file)
  end

  def after_create_hook
    emails = self.application.email_list
    BuildMailer.new_build_available(emails, self).deliver if !emails.empty?
  end

  def generate_manifest!(ipa_reader)
    xml = manifest_content(ipa_reader)
    self.manifest = StringIO.new(xml)
  end

  def manifest_content(ipa_file)
    '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>items</key>
	<array>
		<dict>
			<key>assets</key>
			<array>
				<dict>
					<key>kind</key>
					<string>software-package</string>
					<key>url</key>
					<string>'+ self.ipa.url+ '</string>
				</dict>
			</array>
			<key>metadata</key>
			<dict>
				<key>bundle-identifier</key>
				<string>'+ ipa_file.bundle_identifier+'</string>
				<key>bundle-version</key>
				<string>'+ ipa_file.version+'</string>
				<key>kind</key>
				<string>software</string>
				<key>title</key>
				<string>'+ ipa_file.name+'</string>
			</dict>
		</dict>
	</array>
</dict>
</plist>
'
  end
end
