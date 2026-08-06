# frozen_string_literal: true

class AdminMailer < ApplicationMailer
  def new_researchers
    @researchers = params[:researchers]
    @date = Time.current.strftime('%B %d, %Y')
    @count = @researchers.count

    mail(
      to: ENV.fetch('ADMIN_EMAILS', '').split(', '),
      subject: "SB: #{@count} New Researcher#{'s' unless @count == 1} - #{@date}"
    )
  end
end
