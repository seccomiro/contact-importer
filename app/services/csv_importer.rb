require 'csv'

class CsvImporter
  def initialize(import)
    @import = import
  end

  def fetch_headers
    CSV.open(@import.file.path, &:readline).first.split(';')
       .map { |h| { h => '' } }
       .reduce({}) { |acc, h| acc.merge(h) }
  end
end
