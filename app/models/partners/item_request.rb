# == Schema Information
#
# Table name: item_requests
#
#  id                 :bigint           not null, primary key
#  name               :string
#  partner_key        :string
#  quantity           :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  item_id            :integer
#  partner_request_id :bigint
#
module Partners
  class ItemRequest < Base
    self.table_name = "item_requests"

    belongs_to :request, class_name: 'Partners::ItemRequest', foreign_key: :partner_request_id
  end
end
