require 'csv'

class EthnicityGuesser::Categorizer
  def guess(last_name)
    guess = 'cannot_determine'

    CSV.foreach(last_names_path) do |ethnicity_determination_for_name, name|
      if name.downcase == last_name.downcase
        guess = ethnicity_determination_for_name.downcase
        
        break
      end
    end

    guess
  end

  private

  def last_names_path
    Rails.root.join('lib', 'ethnicity_guesser', 'lookup', 'last_names.csv')
  end
end