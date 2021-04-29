class CreditCardValidation
  def initialize(credit_card_number)
    @credit_card_number = clear_formatting(credit_card_number.to_s)
  end

  def fetch_issuer_name
    fetch_issuer[:issuer]
  end

  def encrypt
    specification = fetch_issuer
    raise 'Invalid credit card length' unless valid_length?(specification)

    Digest::SHA1.hexdigest(@credit_card_number)
  end

  def check_min_max_length
    raise 'Invalid credit card length' unless @credit_card_number.size.between?(8, 19)
  end

  def last_digits
    @credit_card_number.last(4)
  end

  private

  def clear_formatting(credit_card_number)
    credit_card_number.gsub(/[^0-9]/, '')
  end

  def valid_length?(specification)
    length = specification[:length]
    if length.instance_of?(Integer)
      return @credit_card_number.size == length
    elsif length.instance_of?(Range)
      first = length.first
      last = length.last
      return @credit_card_number.size.between?(first, last)
    elsif length.instance_of?(Array)
      length.each do |l|
        return true if @credit_card_number.size == l
      end
    end

    false
  end

  def fetch_issuer
    check_min_max_length
    specifications.each do |specification|
      specification[:iin_ranges].each do |iin_range|
        if iin_range.instance_of?(Integer)
          return specification if @credit_card_number.starts_with?(iin_range.to_s)
        elsif iin_range.instance_of?(Range)
          first = iin_range.first
          last = iin_range.last
          iin_length = first.to_s.size
          return specification if @credit_card_number[0...iin_length].to_i.between?(first, last)
        end
      end
    end
    raise 'Nonexisting issuer'
  end

  def specifications
    [
      { issuer: 'American Express', iin_ranges: [34, 37], length: 15 },
      { issuer: 'Bankcard', iin_ranges: [5610, 560221..560225], length: 16 },
      { issuer: 'China T-Union', iin_ranges: [31], length: 19 },
      { issuer: 'China UnionPay', iin_ranges: [62], length: 16..19 },
      { issuer: 'Diners Club International', iin_ranges: [36], length: 14..19 },
      { issuer: 'Diners Club United States & Canada', iin_ranges: [54], length: 16 },
      { issuer: 'Discover Card', iin_ranges: [6011, 622126..622925, 644, 645, 646, 647, 648, 649, 65], length: 16..19 },
      { issuer: 'UkrCard', iin_ranges: [60400100..60420099], length: 16..19 },
      { issuer: 'RuPay', iin_ranges: [60, 6521, 6522], length: 16 },
      { issuer: 'InterPayment', iin_ranges: [636], length: 16..19 },
      { issuer: 'InstaPayment', iin_ranges: [637..639], length: 16 },
      { issuer: 'JCB', iin_ranges: [3528..3589], length: 16..19 },
      { issuer: 'Laser', iin_ranges: [6304, 6706, 6771, 6709], length: 16..19 },
      { issuer: 'Maestro UK', iin_ranges: [6759, 676770, 676774], length: 12..19 },
      { issuer: 'Maestro', iin_ranges: [5018, 5020, 5038, 5893, 6304, 6759, 6761, 6762, 6763], length: 12..19 },
      { issuer: 'Dankort', iin_ranges: [5019, 4571], length: 16 },
      { issuer: 'MIR', iin_ranges: [2200..2204], length: 16..19 },
      { issuer: 'NPS Pridnestrovie', iin_ranges: [6054740..6054744], length: 16 },
      { issuer: 'Mastercard', iin_ranges: [2221..2720, 51..55], length: 16 },
      { issuer: 'Solo', iin_ranges: [6334, 6767], length: [16, 18, 19] },
      { issuer: 'Switch', iin_ranges: [4903, 4905, 4911, 4936, 564182, 633110, 6333, 6759], length: [16, 18, 19] },
      { issuer: 'Troy', iin_ranges: [9..6], length: 16 },
      { issuer: 'Visa', iin_ranges: [4], length: [13, 16] },
      { issuer: 'Visa Electron', iin_ranges: [4026, 417500, 4508, 4844, 4913, 4917], length: 16 },
      { issuer: 'UATP', iin_ranges: [1], length: 15 },
      { issuer: 'Verve', iin_ranges: [506099..506198, 650002..650027], length: [16, 19] },
      { issuer: 'LankaPay', iin_ranges: [357111], length: 16 }
    ]
  end
end
