# == Schema Information
#
# Table name: partner_requests
#
#  id              :bigint           not null, primary key
#  comments        :text
#  for_families    :boolean
#  sent            :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint
#  partner_id      :bigint
#
module Partners
  class Request < Base
    self.table_name = "partner_requests"

    belongs_to :partner, dependent: :destroy
    has_many :item_requests, class_name: 'Partners::ItemRequest', foreign_key: :partner_request_id, dependent: :destroy, inverse_of: :request
    accepts_nested_attributes_for :item_requests

    validates_associated :item_requests
    validates :item_requests, presence: true
  end
end
