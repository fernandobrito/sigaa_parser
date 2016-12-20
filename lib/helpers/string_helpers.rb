# Monkey patch String class to add utility method to remove
# tabulation and white spaces from string.
class String
  # Removes \n, \t and multiple spaces
  def remove_tabulation
    gsub(/(\n|\t)/, ' ').gsub(/\s+/, ' ').strip
  end
end
