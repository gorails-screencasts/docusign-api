class AddDocusignEnvelopeIdToEnvelopes < ActiveRecord::Migration[5.0]
  def change
    add_column :envelopes, :docusign_envelope_id, :string
  end
end
