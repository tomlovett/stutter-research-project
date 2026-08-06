# frozen_string_literal: true

class Study < ApplicationRecord
  belongs_to :researcher
  has_many :connections, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_one :location, dependent: :destroy

  accepts_nested_attributes_for :location, reject_if: :all_blank, allow_destroy: true

  scope :draft, -> { where('published_at IS NULL AND closed_at IS NULL') }
  scope :active, -> { where('published_at IS NOT NULL AND closed_at IS NULL AND paused_at IS NULL') }
  scope :paused, -> { where.not(paused_at: nil) }
  scope :published, -> { where.not(published_at: nil) }
  scope :closed, -> { where.not(closed_at: nil) }
  scope :digital_friendly, -> { where(location_type: [HYBRID, DIGITAL]) }
  scope :survey_only, -> { where(survey_only: true) }

  DIGITAL = 'digital'
  HYBRID = 'hybrid'
  IN_PERSON = 'in_person'

  def as_json(options = {})
    result = super(options.merge(include: :location))

    if Current.user&.participant
      invitation = invitations.find_by(participant: Current.user.participant)
      connection = connections.find_by(participant: Current.user.participant)
      result['invitation'] = invitation&.as_json
      result['connection'] = connection&.as_json
    end

    result
  end

  def address
    return '' if location_type == DIGITAL || location.nil?

    [location.city, location.state, location.country].compact.join(', ')
  end

  def short_addr
    return 'Online' if location_type == DIGITAL
    return 'To be assigned' if location.nil?

    city_state = "#{location.city}, #{location.state}"
    location_type == HYBRID ? "Online / #{city_state}" : "#{city_state}, #{location.country}"
  end

  def status
    return 'paused' if paused?
    return 'draft' unless published?
    return 'closed' if closed?

    'active'
  end

  def timeline
    if total_sessions == 1
      "#{total_hours} #{total_hours == 1 ? 'hour' : 'hours'} in one session"
    else
      "#{total_hours} #{total_hours == 1 ? 'hour' : 'total hours'} in #{total_sessions} " \
        "sessions over the course of #{duration}"
    end
  end

  def age_range
    return 'All ages' unless min_age? || max_age?

    if min_age?
      max_age? ? "#{min_age}-#{max_age}" : "#{min_age} and up"
    else
      "#{max_age} and under"
    end
  end

  def paused?
    paused_at.present?
  end

  def published?
    published_at.present?
  end

  def closed?
    closed_at.present?
  end
end
