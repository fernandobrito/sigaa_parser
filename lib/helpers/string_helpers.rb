class String
  # Removes \n, \t and multiple spaces
  def remove_tabulation
    self.gsub(/(\n|\t)/, ' ').gsub(/\s+/, ' ').strip
  end
end