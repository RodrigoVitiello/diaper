# == Schema Information
#
# Table name: children
#
#  id                   :bigint           not null, primary key
#  active               :boolean          default(TRUE)
#  archived             :boolean
#  child_lives_with     :jsonb
#  comments             :text
#  date_of_birth        :date
#  first_name           :string
#  gender               :string
#  health_insurance     :jsonb
#  item_needed_diaperid :integer
#  last_name            :string
#  race                 :jsonb
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  agency_child_id      :string
#  family_id            :bigint
#
module Partners
  class Child < Base
    CAN_LIVE_WITH = %w[Mother Father Grandparent Foster\ Parent Other\ Parent/Relative].freeze
    RACES = %w[African\ American Caucasian Hispanic Asian American\ Indian Pacific\ Islander Multi-racial Other].freeze

    belongs_to :family
  end
end

