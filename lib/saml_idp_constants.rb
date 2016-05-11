# Global constants used by the SAML IdP
module Saml
  module Idp
    module Constants
      PASSWORD_SPECIAL_CHARS = "!\"\#$%&'()*+,-.:;<=>?@[]{}/\\^_~`|".freeze
      LOA1_AUTHNCONTEXT_CLASSREF = 'http://idmanagement.gov/ns/assurance/loa/1'.freeze
      LOA3_AUTHNCONTEXT_CLASSREF = 'http://idmanagement.gov/ns/assurance/loa/3'.freeze
    end
  end
end