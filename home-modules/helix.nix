{
  programs.helix =
  {
    enable = true;
    defaultEditor = true;
  
    settings =
    {
      theme = "tokyonight";
      editor =
      {
        rulers = [ 80 120 ];
        line-number = "relative";
        bufferline = "always";
        auto-completion = true;
        middle-click-paste = false;
        color-modes = true;
        end-of-line-diagnostics = "hint";
        completion-trigger-len = 2;

        inline-diagnostics =
        {
          cursor-line = "warning";
        };

        auto-save =
        {
          focus-lost = true;
          after-delay.enable = false;
        };

        cursor-shape =
        {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        whitespace =
        {
          render =
          {
            space = "all";
            tab = "all";
            nbsp = "none";
            nnbsp = "none";
            newline = "none";
          };
          characters =
          {
            space = "·";
            nbsp = "⍽";
            nnbsp = "␣";
            tab = "→";
            newline = "⏎";
            tabpad = "·";
          };
        };

        statusline =
        {
          mode =
          {
            normal = "NORMAL";
            insert = "INSERT";
            select = "SELECT";
          };
        };

        indent-guides =
        {
          render = true;
          character = "╎";
          skip-levels = 1;
        };

        file-picker =
        {
          hidden = false;
        };

        lsp =
        {
          enable = true;
          display-messages = true;
        };
      
        smart-tab =
        {
          enable = false;
        };
      };

      keys.normal =
      {
        p = "paste_clipboard_before";
        y = "yank_main_selection_to_clipboard";

        "C-x" = ":buffer-close";
      };
    };

    languages =
    {
      language-server.zk =
      {
        command = "zk";
        args = ["lsp"];
      };
      language =
      [
        {
          name = "markdown";
          language-servers = ["zk"];
          auto-format = true;
          formatter =
          {
            command = "prettier";
            args = ["--parser" "markdown"];
          };
        }
        {
          name = "cpp";
          language-servers = ["clangd"];
          auto-format = true;
          formatter =
          {
            command = "clang-format";
          };
        }
      ];
    };
  };
}
