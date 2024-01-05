D = Steep::Diagnostic

target :lib do
  signature "sig", "rgss/sig"

  check "Data/Scripts/001_Technical"
  #check "Plugins"

  library "json"
  library "minitest"

  configure_code_diagnostics(D::Ruby.strict)
end