return {
  {
    "lfv89/vim-interestingwords",
    init = function()
      vim.g.interestingWordsDefaultMappings = 0
      vim.g.interestingWordsGUIColors = {
        "#8CCBEA", "#A4E57E", "#FFDB72", "#FF7272", "#FFB3FF", "#9999FF",
      }
    end,
    keys = {
      {
        "<Space>mm",
        function() vim.fn.InterestingWords("n") end,
        desc = "Toggle word highlight",
      },
      {
        "<Space>mc",
        function() vim.fn.UncolorAllWords() end,
        desc = "Clear word highlights",
      },
      {
        "<Space>mn",
        function() vim.fn.WordNavigation(1) end,
        desc = "Next highlighted word occurrence",
      },
      {
        "<Space>mp",
        function() vim.fn.WordNavigation(0) end,
        desc = "Previous highlighted word occurrence",
      },
    },
  },
}
