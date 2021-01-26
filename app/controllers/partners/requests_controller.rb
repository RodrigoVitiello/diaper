module Partners
  class RequestsController < BaseController
    layout 'partners/application'

    protect_from_forgery with: :exception

    def index
      @partner = current_partner_user.partner
      @partner_requests = @partner.requests.order(created_at: :desc).limit(10)
    end

    def new
      @partner_request = Partners::Request.new
      @partner_request.item_requests.build

      # Fetch the valid items
      @requestable_items = Organization.find(current_partner_user.partner.diaper_bank_id).valid_items.map do |item|
        [item[:name], item[:id]]
      end.sort
    end

    def create
      @partner_request = Partners::Request.new(partner_request_params.merge(partner_id: current_partner_user.id))
      @partner_request.item_requests << create_item_requests

      @requestable_items = Organization.find(current_partner_user.partner.diaper_bank_id).valid_items.map do |item|
        [item[:name], item[:id]]
      end.sort

      if @partner_request.save
        redirect_to partner_user_root_path, notice: "Request was successfully created."
      else
        render :new
      end
    end

    private

    def partner_request_params
      params.require(:partners_request).permit(:comments, item_requests_attributes: [
                                                 :item_id,
                                                 :quantity,
                                                 :_destroy
                                               ])
    end

    def get_full_item_values(id)
      @valid_items ||= Organization.find(current_partner_user.partner.diaper_bank_id).valid_items
      @valid_items.find { |vi| vi[:id].to_s == id }
    end

    def create_item_requests
      item_params = params.dig("partners_request", "item_requests_attributes")&.values
      item_params.reject! { |item| item["item_id"].empty? }

      item_params.map do |item|
        full_item = get_full_item_values(item["item_id"])
        Partners::ItemRequest.new(
          item_id: item["item_id"],
          quantity: item["quantity"],
          name: full_item["name"],
          partner_key: full_item["partner_key"]
        )
      end
    end
  end
end

