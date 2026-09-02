{
  # GIT
  plugins.lazygit.enable = true;
  plugins.gitblame = {
    enable = true;
    settings.enable = false;
    settings.date_format = "%r";
  };
  plugins.diffview = {
    enable = true;
    settings = {
      default_args = {
        DiffviewOpen = [ "--imply-local" ];
      };
    };
  };
  # plugins.git-conflict.enable = true;
  plugins.codediff.enable = true;
}
