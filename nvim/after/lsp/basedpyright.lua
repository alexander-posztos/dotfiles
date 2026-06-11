return {
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = 'off',
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticSeverityOverrides = {
          reportMissingTypeStubs = 'none',
        },
      },
    },
  },
}
