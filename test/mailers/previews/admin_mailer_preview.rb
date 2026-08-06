# frozen_string_literal: true

class AdminMailerPreview < ActionMailer::Preview
  def new_researchers
    # http://localhost:3000/rails/mailers/admin_mailer/new_researchers
    researchers = [
      FactoryBot.create(:researcher, university_profile_url: 'https://university.edu/profiles/jane-smith',
                                     created_at: 2.hours.ago),
      FactoryBot.create(:researcher, university_profile_url: nil, created_at: 5.hours.ago),
      FactoryBot.create(:researcher, university_profile_url: 'https://research.edu/faculty/maria-garcia',
                                     created_at: 12.hours.ago)
    ]

    AdminMailer.with(researchers:).new_researchers
  end
end
