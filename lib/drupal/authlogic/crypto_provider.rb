require "digest/md5"

module Drupal
  module Authlogic
    class CryptoProvider
      class << self
        # Turns your raw password into a MD5 hash. Use only the first as we don't care about the salt.
        def encrypt(*tokens)
          Digest::MD5.hexdigest(tokens.first)
        end
      
        # Does the crypted password match the tokens? Use only the first as we don't care about the salt.
        def matches?(crypted, *tokens)
          encrypt(*tokens) == crypted
        end
      end
    end
  end
end
