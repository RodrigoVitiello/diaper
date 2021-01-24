RSpec.describe "Managing requests", type: :system, js: true do
  describe 'creating a request' do
    let!(:partner_user) { FactoryBot.create(:partners_user) }

    context 'GIVEN a partner user is permitted to make a request' do
      before do
        login_as(partner_user, scope: :partner_user)
        visit new_partners_request_path
      end

      context 'WHEN they create a request properly' do
        let(:items_to_select) do
          Organization.find(partner_user.partner.diaper_bank_id).valid_items.sample(3)
        end

        before do
          fill_in 'Comments', with: Faker::Lorem.paragraph
          select "Adult Cloth Diapers (Large/XL/XXL)", from: 'partners_request_item_requests_item_id'
          fill_in 'partners_request_item_requests_quantity', with: 5
          find_link('Add Another Item').click
        end

        it 'THEN a request will be created and the partner will be notified' do
          expect(Request.all.count).to eq(1)
          expect(Request.all.count).to eq(1)
        end
      end
    end
  end
end


