D = Steep::Diagnostic

target :lib do
  signature "sig", "rgss/sig"

  check "Plugins"

  library "json"
  library "minitest"

  configure_code_diagnostics(D::Ruby.strict)
end