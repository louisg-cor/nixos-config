{ config, pkgs, ... }:
{
  programs.zk =
  {
    enable = true;
    settings =
    {
      note =
      {
        language = "fr";
        default-title = "Sans titre";
        filename = "{{title}}-{{id}}";
        extension = "md";
        template = "default.md";
        exclude =
        [
          "*.d2"
          ".git/*"
        ];
      };

      extra = {};

      format.markdown =
      {
        link-format = "wiki";
        frontmatter = "yaml";
        hashtags = true;
        colon-tags = true;
      };

      tool =
      {
        editor = "hx";
        pager = "less -FIRX";
      };

      lsp.diagnostics =
      {
        dead-link = "error";
      };

      alias =
      {
        ls = "zk list $@";
        editlast = "zk edit --limit 1 --sort modified- $@";
        n = "zk new --title $@";
        f = "zk edit --interactive";
      };
    };
  };
}
