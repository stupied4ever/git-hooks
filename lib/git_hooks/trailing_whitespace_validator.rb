module GitHooks
  class TrailingWhitespaceValidator
    def errors?(files)
      files
        .map { |file| File.open(file) }
        .map(&:read)
        .grep(/ +$/)
        .compact
        .any?
    end
  end
end
