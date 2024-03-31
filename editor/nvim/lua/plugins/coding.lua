return {

  {
    "m4xshen/autoclose.nvim",
    event = "BufEnter",
    config = function()
      require("autoclose").setup()
    end,
  }, 

   {
    "Bryley/neoai.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim",
    }, 
   }
}
