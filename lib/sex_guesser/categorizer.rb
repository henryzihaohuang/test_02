require 'csv'

class SexGuesser::Categorizer
  def guess_sex(first_name)
    guess = 'Cannot be determined'

    first_initial = name_initial(first_name)

    unless ('A'..'Z').include?(first_initial)
      guess = 'Dataset not available'
      return
    end

    CSV.foreach(available_names_path(first_initial)) do |name, sex_determination_for_name|
      if name.downcase == first_name.downcase.gsub('.', '')
        if sex_determination_for_name == 'Unisex'
          guess = 'Cannot be determined'
        else
          guess = sex_determination_for_name
        end
        break
      end
    end

    guess
  end

  private

  def available_names_path(first_initial)
    Rails.root.join('lib', 'sex_guesser', 'lookup') + "#{first_initial}.csv"
  end

  def name_initial(first_name)
    return unless first_name
    first_name[0].upcase
  end
end