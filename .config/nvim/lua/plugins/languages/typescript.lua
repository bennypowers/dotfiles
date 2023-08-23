return { 'pmizio/typescript-tools.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'neovim/nvim-lspconfig',
  },
  opts = {
    on_attach = function(client, bufnr)
      require 'lsp-status'.on_attach(client)
      require 'nvim-navic'.attach(client, bufnr)
    end,
    settings = {
      tsserver_file_preferences = {
        quotePreference = "auto",
        importModuleSpecifierEnding = "js",
        jsxAttributeCompletionStyle = "auto",
        allowTextChangesInNewFiles = true,
        providePrefixAndSuffixTextForRename = true,
        allowRenameOfImportPath = true,
        includeAutomaticOptionalChainCompletions = true,
        provideRefactorNotApplicableReason = true,
        generateReturnInDocTemplate = true,
        includeCompletionsForImportStatements = true,
        includeCompletionsWithSnippetText = true,
        includeCompletionsWithClassMemberSnippets = true,
        includeCompletionsWithObjectLiteralMethodSnippets = true,
        useLabelDetailsInCompletionEntries = true,
        allowIncompleteCompletions = true,
        displayPartsForJSDoc = true,
        disableLineTextInReferences = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
      tsserver_format_options = {
        insertSpaceAfterCommaDelimiter = true,
        insertSpaceAfterConstructor = false,
        insertSpaceAfterSemicolonInForStatements = true,
        insertSpaceBeforeAndAfterBinaryOperators = true,
        insertSpaceAfterKeywordsInControlFlowStatements = true,
        insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
        insertSpaceBeforeFunctionParenthesis = false,
        insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false,
        insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false,
        insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
        insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = true,
        insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false,
        insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = false,
        insertSpaceAfterTypeAssertion = false,
        placeOpenBraceOnNewLineForFunctions = false,
        placeOpenBraceOnNewLineForControlBlocks = false,
        semicolons = "ignore",
        indentSwitchCase = true,
      },
      tsserver_plugins = {
        'typescript-lit-html-plugin',
        'lit-ts-plugin',
      },
    },
  },
}

-- return { 'jose-elias-alvarez/typescript.nvim',
--   name = 'typescript',
--   config = {
--     disable_commands = false,
--     server = {
--       on_attach = function(client, bufnr)
--         require 'lsp-status'.on_attach(client)
--         require 'nvim-navic'.attach(client, bufnr)
--       end,
--       settings = {
--         format = false,
--         typescript = {
--           inlayHints = {
--             includeInlayParameterNameHints = 'all',
--             includeInlayParameterNameHintsWhenArgumentMatchesName = false,
--             includeInlayFunctionParameterTypeHints = true,
--             includeInlayVariableTypeHints = true,
--             includeInlayPropertyDeclarationTypeHints = true,
--             includeInlayFunctionLikeReturnTypeHints = true,
--             includeInlayEnumMemberValueHints = true,
--           }
--         },
--         javascript = {
--           inlayHints = {
--             includeInlayParameterNameHints = 'all',
--             includeInlayParameterNameHintsWhenArgumentMatchesName = false,
--             includeInlayFunctionParameterTypeHints = true,
--             includeInlayVariableTypeHints = true,
--             includeInlayPropertyDeclarationTypeHints = true,
--             includeInlayFunctionLikeReturnTypeHints = true,
--             includeInlayEnumMemberValueHints = true,
--           }
--         }
--       },
--     },
--   },
-- }

