D = Steep::Diagnostic

target :lib do
  signature "sig", "rgss/sig"

  check "Data/Scripts/001_Technical"
  #check "Plugins"

  library "json"
  library "minitest"

  configure_code_diagnostics(D::Ruby.strict) do |hash|
    hash[D::Ruby::NoMethodByNil] = nil
    hash[D::Ruby::ArgumentTypeNilabilityMismatch] = nil
    hash[D::Ruby::FallbackAny] = nil
  end
end