class EmailCheck < ApplicationRecord
  validates :email, presence: true
  validates :status, presence: true

  enum status: {
    on_hold: 0, checking: 1, good: 2, bad: 3,
    catch_all: 4, unknown: 5, spamtrap: 6, abuse: 7, do_not_mail: 8
  }

  def contacts
    Contact.where(email: email)
  end

  def register_status(status)
    raise 'Invalid status' unless status_map.key?(status)

    self.status = status_map[status]
  end

  private

  def status_map
    {
      'on_hold' => :on_hold,
      'checking' => :checking,
      'valid' => :good,
      'invalid' => :bad,
      'catch-all' => :catch_all,
      'unknown' => :unknown,
      'spamtrap' => :spamtrap,
      'abuse' => :abuse,
      'do_not_mail' => :do_not_mail
    }
  end
end
