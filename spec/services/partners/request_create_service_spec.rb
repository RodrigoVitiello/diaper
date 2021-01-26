require 'rails_helper'

describe Partners::RequestCreateService do

  describe '#call' do
    subject { described_class.new(args).call }
    let(:args) do
      {
        partner_id: partner_user.id,
        comments: comments,
        item_requests_attributes: item_requests_attributes
      }
    end
    let(:partner_user) { FactoryBot.create(:partners_user) }
    let(:comments) { Faker::Lorem.paragraph }
    let(:item_requests_attributes) do
      [
        {
          item_id: FactoryBot.create(:item).id,
          quantity: Faker::Number.within(range: 1..10)
        }
      ]
    end

    context 'when the arguments are incorrect' do
      context 'because no item_requests_attributes were defined' do
        let(:item_requests_attributes) { [] }

        it 'should return the Partners::Request object with an error' do
          result = subject

          expect(result).to be_a_kind_of(Partners::RequestCreateService)
          expect(result.errors[:item_requests]).to eq(["can't be blank"])
        end
      end

      context 'because a unrecogonized item_id was provided' do
        let(:item_requests_attributes) do
          [
            {
              item_id: 0,
              quantity: Faker::Number.within(range: 1..10)
            }
          ]
        end

        it 'should return the Partners::Request object with an error' do
          result = subject

          expect(result).to be_a_kind_of(Partners::RequestCreateService)
          expect(result.errors[:"item_requests.name"]).to eq(["can't be blank"])
        end
      end
    end

    context 'when the arguments are correct' do
      it 'should create a Partners::Request model along with the Request model' do

      end

      it 'should notify the Partner via email' do

      end
    end
  end
end
