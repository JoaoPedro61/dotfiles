return {
  {
    "echasnovski/mini.hipatterns",
    event = "BufReadPre",
    version = "*",
    opts = {
      highlighters = {
        fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
        todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
        note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
      },
    },
    config = function(_, opts)
      local hipatterns = require("mini.hipatterns")

      opts.highlighters.hex_color = hipatterns.gen_highlighter.hex_color()

      hipatterns.setup(opts)
    end,
  },
}
