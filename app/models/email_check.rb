class EmailCheck < ApplicationRecord
  validates :email, presence: true
  validates :status, presence: true

  enum status: {
    checking: 0, good: 1, bad: 2,
    catch_all: 3, unknown: 4, spamtrap: 5, abuse: 6, do_not_mail: 7
  }

  before_validation :ensure_status

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

  def ensure_status
    self.status = :checking unless status
  end
end
