{ pkgs, ... }:

{
  home.sessionVariables = {
    VISUAL = "nvim";
    EDITOR = "nvim";

    # Do not track
    DO_NOT_TRACK = "1";
    HOMEBREW_NO_ANALYTICS = "1";
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";

    # Path
    PATH = "$PATH:$HOME/bin";
  };

  programs.direnv.enable = true;
  programs.zoxide.enable = true;
  programs.zoxide.enableFishIntegration = true;

  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set fish_greeting
      any-nix-shell fish --info-right | source
    '';

    shellAliases = {
      mv = "mv -iv";
      cp = "cp -riv";
      mkdir = "mkdir -vp";
      ls = "ls --color=auto";
    };

    shellAbbrs = {
      # ls
      la = "ls -A";
      lla = "ls -al";
      ll = "ls -l";

      # Git
      ga  = "git add";
      gaa = "git add --all";
      gap = "git add -p";
      gc = "git commit -m";
      gca = "git commit --amend";
      gcd = "git checkout development";
      gcm = "git checkout master";
      gcma = "git checkout main";
      gco = "git checkout";
      ghpr = "gh pr create -w";
      gl = "git log";
      gld = "git log --graph --oneline origin/development..";
      glm = "git log --graph --oneline origin/master..";
      glma = "git log --graph --oneline origin/main..";
      gp = "git push";
      gpf = "git push -f";
      gpr = "git pull --rebase";
      grod = "git fetch -p; git rebase origin/development";
      grom = "git fetch -p; git rebase origin/master";
      groma = "git fetch -p; git rebase origin/main";
      gst = "git status";

      # Elixir
      iem = "iex -S mix";
      mixg = "mix gettext.setup";
      mps = "iex -S mix phx.server";
      mup = "npm install && npm run-script build && mix do deps.get, ecto.migrate";
      mups = "npm install && npm run-script build && mix do deps.get, ecto.migrate && iex -S mix phx.server";

      # Heroku
      hr = "heroku restart -a";
    };

    functions = {
      # Check if git rebase strings are still present
      git-rebase-strings = "rg \"(<<<<|>>>>)\" || echo \"No rebase strings found\"";

      # Restart detroit- app
      hrd = "heroku restart -a detroit-$argv[1]";

      # Run command N times
      run = ''
        set number $argv[1]

        for i in (seq $number)
          eval $argv[2..-1]
        end
      '';
    };

    plugins = [
      {
        name = "fish-command-timer";
        src = pkgs.fetchFromGitHub {
          owner = "jichu4n";
          repo = "fish-command-timer";
          rev = "ba68bd0a1d06ea99aadefe5a4f32ff512783d432";
          sha256 = "Ip677gZlcO8L/xukD7Qoa+C+EcI2kGd+BSOi2CDOzM4=";
        };
      }

      {
        name = "lucid";
        src = pkgs.fetchFromGitHub {
          owner = "mattgreen";
          repo = "lucid.fish";
          rev = "b6aca138ce47289f2083bcb63c062d47dcaf4368";
          sha256 = "6HepVxMm9LdJoifczvQS98kAc1+RTKJh+OHRf28nhZM=";
        };
      }
    ];
  };
}
