class Envelope < ApplicationRecord
  has_many :envelope_users
  has_many :users, through: :envelope_users

  def self.create_from_template(template_id, roles={})
    envelope = Envelope.new(docusign_template_id: template_id)

    roles.each do |role, user|
      envelope.envelope_users.new(role: role, user_id: user.id)
    end

    client = DocusignRest::Client.new
    envelope_response = client.create_envelope_from_template(
      status: 'sent',
      email: {
        subject: "TEST SUBJECT",
        body: "TEST BODY"
      },
      template_id: template_id,
      signers: envelope.envelope_users.map{ |eu| {role_name: eu.role, name: eu.user.name, email: eu.user.email} },
      event_notification: {
        url: "http://4da02d2b.ngrok.io/docusign/webhooks.xml",
        logging: true,
        envelope_events: [
          {envelope_event_status_code: "sent"},
          {envelope_event_status_code: "delivered"},
          {envelope_event_status_code: "completed"},
          {envelope_event_status_code: "declined"},
          {envelope_event_status_code: "voided"}
        ]
      }
    )

    envelope.update(docusign_envelope_id: envelope_response["envelopeId"], status: envelope_response["status"])
    envelope
  end
end

#user = User.create(name: "Chris Oliver", email: "chris@gorails.com")
#Envelope.create_from_template(
  #"2d32b8d1-2a65-4f98-8f00-2ee1506500fa",
  #{
    #"Seller" => user,
  #}
#)
