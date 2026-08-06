# frozen_string_literal: true

class RemoveLastVerifiedActiveFromStudies < ActiveRecord::Migration[8.0]
  def change
    remove_column :studies, :last_verified_active, :datetime, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
