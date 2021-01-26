module Partners
  class RequestCreateService
    include ServiceObjectErrorsMixin

    attr_reader :partner_request

    def initialize(partner_id:, comments: nil, item_requests_attributes: [])
      @partner_id = partner_id
      @comments = comments
      @item_requests_attributes = item_requests_attributes
    end

    def call
      @partner_request = Partners::Request.new(partner_id: partner_id, comments: comments)
      @partner_request = populate_item_request(@partner_request)

      unless @partner_request.valid?
        @partner_request.errors.each do |k, v|
          errors.add(k, v)
        end
      end

      return self if errors.present?
    end

    private

    attr_reader :partner_id, :comments, :item_requests_attributes

    def populate_item_request(partner_request)
      item_requests = item_requests_attributes.map do |ira|
        Partners::ItemRequest.new(
          item_id: ira[:item_id],
          quantity: ira[:quantity],
          name: fetch_organization_item_name(ira[:item_id]),
          partner_key: fetch_orgnaization_partner_key(ira[:item_id])
        )
      end

      partner_request.item_requests << item_requests

      partner_request
    end

    def fetch_organization_item_name(item_id)
      item_data = organization_item_data.find { |item| item[:id] == item_id }
      if item_data.present?
        item_data[:name]
      end
    end

    def fetch_orgnaization_partner_key(item_id)
      item_data = organization_item_data.find { |item| item[:id] == item_id }
      if item_data.present?
        item_data[:partner_key]
      end
    end

    def organization_item_data
      @organization_item_data ||= Organization.find_by(id: organization_id).valid_items
    end

    def organization_id
      @organization_id ||= Partners::User.find_by(partner_id: partner_id).partner.diaper_bank_id
    end

  end
end
