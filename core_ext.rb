class String
  def capitalize
    (slice(0) || '').upcase + (slice(1..-1) || '').downcase
  end
end