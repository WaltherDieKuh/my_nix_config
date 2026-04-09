{ config, pkgs, lib, ... }: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = builtins.fromTOML ''
      # Get editor completions based on the config schema
      "$schema" = 'https://starship.rs/config-schema.json'

      # Inserts a blank line between shell prompts:
      add_newline = true

      format = """
      [╭╴](fg:#505050)\
      $os\
      $shell\
      $username\
      $hostname\
      $sudo\
      $directory\
      $git_branch$git_commit$git_state$git_metrics$git_status\
      [ ](fg:#252525)\
      $fill\
      [ ](fg:#252525)\
      $direnv\
      $container\
      $kubernetes\
      $aws\
      $docker_context\
      $terraform\
      $package\
      $rust\
      $nodejs\
      $python\
      $php\
      $golang\
      $java\
      $status\
      $jobs\
      $memory_usage\
      $cmd_duration\
      $battery\
      $time\
      $localip\
      $line_break\
      \
      [╰╴](fg:#505050)\
      [$character]($style)"""

      # move the rest of the prompt to the right
      right_format = """"""

      # Customization and activation of some modules:
      # Listed in the order of their position in the module row above
      [os]
      format = "[](fg:#252525)[$symbol]($style)(bg:#252525)"
      style = "fg:#AAAAAA bg:#252525"
      disabled = false # set to 'true' to hide the OS module if there are performance issues

      [os.symbols] # Remove Comment to Show your OS symbols
      Mint = "\uf30e "

      [shell]
      # See https://starship.rs/config/#shell
      format = '[$indicator]($style)()'
      style = 'fg:#424242 bg:#252525'
      zsh_indicator = '%_ '
      bash_indicator = '\\$_ '
      fish_indicator = '>> '
      powershell_indicator = '>_ '
      unknown_indicator = '?_ '
      disabled = false

      [username]
      # See https://starship.rs/config/#username
      format = '[ ](fg:green bold bg:#252525)[$user]($style)[ ](bg:#252525)'
      style_user = 'fg:green bold bg:#252525'
      style_root = 'fg:red bold bg:#252525'
      show_always = false
      disabled = false

      [hostname]
      # See https://starship.rs/config/#hostname
      format = '[$ssh_symbol ](fg:green bold bg:#252525)[$hostname](fg:green bold bg:#252525)[ ](bg:#252525)'
      ssh_only = true
      ssh_symbol = ''
      disabled = false

      [sudo]
      # See https://starship.rs/config/#sudo
      format = '[ ](fg:red bold bg:#252525)[ $symbol]($style)'
      style = 'fg:red bold bg:#252525'
      symbol = ' '
      disabled = true

      [directory]
      # See https://starship.rs/config/#directory
      format = '[ ](fg:cyan bold bg:#252525)[$read_only]($read_only_style)[$repo_root]($repo_root_style)[$path ]($style)'
      style = 'fg:cyan bold bg:#252525'
      home_symbol = ' ~'
      read_only = ' '
      read_only_style = 'fg:cyan bg:#252525'
      truncation_length = 3
      truncation_symbol = ' '
      truncate_to_repo = true
      repo_root_format = '[ ](fg:cyan bold bg:#252525)[$read_only]($read_only_style)[$before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path ]($style)'
      repo_root_style	= 'fg:cyan bold bg:#252525'
      use_os_path_sep = true
      disabled = false

      # Development environment indicators
      [direnv]
      # See https://starship.rs/config/#direnv
      symbol = 'direnv'
      style = 'fg:#505050 bold bg:#252525'
      format = "[ ❯ $symbol $loaded/$allowed ]($style)"
      allowed_msg = 'a'
      not_allowed_msg = '!a'
      denied_msg = 'x'
      loaded_msg = '+'
      unloaded_msg = '-'
      disabled = false

      [php]
      # See https://starship.rs/config/#php
      format = "[[ 〉](fg:#7a86b8 bg:#252525)[$symbol](fg:#7a86b8 italic bg:#252525)($version )]($style)"
      style = 'fg:#7a86b8 bg:#252525'
      symbol = "php "

      [python]
      # See https://starship.rs/config/#python
      format = "[〉''${symbol}''${pyenv_prefix}(''${version} )((''${virtualenv}) )]($style)"
      style = 'fg:yellow bg:#252525'
      symbol = " "
      pyenv_version_name = false

      [git_branch]
      # See https://starship.rs/config/#git-branch
      format = '[❯ $symbol $branch(:$remote_branch)]($style)[ ](bg:#252525)'
      style = 'fg:#E04D27 bg:#252525'
      symbol = ''

      [git_commit]
      # See https://starship.rs/config/#git-commit
      format = '[\($hash$tag\)]($style)[ ](bg:#252525)'
      style = 'fg:#E04D27 bg:#252525'
      commit_hash_length = 8
      tag_symbol = '  '
      tag_disabled = false
      disabled = false

      [git_metrics]
      # See https://starship.rs/config/#git-metrics
      format = '[\[+$added/]($added_style)[-$deleted\]]($deleted_style)[ ](bg:#252525)'
      added_style = 'fg:#E04D27 bg:#252525'
      deleted_style = 'fg:#E04D27 bg:#252525'
      disabled = false

      [git_status]
      # See https://starship.rs/config/#git-status
      format = '([$all_status$ahead_behind]($style))'
      style = 'fg:#E04D27 bg:#252525'
      conflicted = '[''${count} ](fg:red bg:#252525)'
      ahead = '[⇡''${count} ](fg:yellow bg:#252525)'
      behind = '[⇣''${count} ](fg:yellow bg:#252525)'
      diverged = '[⇕''${ahead_count}⇡''${behind_count}⇣ ](fg:yellow bg:#252525)'
      up_to_date = '[✓ ](fg:green bg:#252525)'
      untracked = '[ﳇ''${count} ](fg:red bg:#252525)'
      stashed = '[''${count} ](fg:#A52A2A bg:#252525)'
      modified = '[󰷉''${count} ](fg:#C8AC00 bg:#252525)'
      staged = '[''${count} ](fg:green bg:#252525)'
      renamed = '[''${count} ](fg:yellow bg:#252525)'
      deleted = '[﯊''${count} ](fg:orange bg:#252525)'
      disabled = false

      # System status indicators
      [fill]
      # See https://starship.rs/config/#fill
      style = 'fg:#505050'
      symbol = "    " 

      [status]
      # See https://starship.rs/config/#status
      format = '[$symbol $status $hex_status(  $signal_number-$signal_name)]($style)'
      style = 'fg:red bg:#252525'
      symbol = ' ✘'
      disabled = false

      [jobs]
      # See https://starship.rs/config/#jobs
      format = "[  ](fg:blue bold bg:#252525)[$symbol $number]($style)"
      style = 'fg:blue bg:#252525'
      symbol = ""
      symbol_threshold = 1
      number_threshold = 2
      disabled = false

      [memory_usage]
      # See https://starship.rs/config/#memory_usage
      format = "[  ](fg:purple bold bg:#252525)[$symbol ''${ram} ''${swap}]($style)"
      style = 'fg:purple bg:#252525'
      symbol = '﬙ 北'
      threshold = 75
      disabled = false

      [cmd_duration]
      # See https://starship.rs/config/#cmd_duration
      format = "[  $duration]($style)"
      style = 'fg:#ffa500 bg:#1e1e1e'
      min_time = 500
      disabled = false

      [battery]
      format = "[  $symbol$percentage]($style)"
      full_symbol = '󰁹 '
      charging_symbol = '󰂄 '
      discharging_symbol = '󰂃 '
      unknown_symbol = '󰁽? '
      empty_symbol = '󰂎 '
      disabled = true # set to 'false', if you want to see the battery status

      [[battery.display]]
      threshold = 20
      style = "fg:#ff6b6b bg:#1e1e1e"  # Red for low battery

      [[battery.display]]
      threshold = 50
      style = "fg:#fcbf49 bg:#1e1e1e"  # Amber for medium battery

      [[battery.display]]
      threshold = 100
      style = "fg:#a0e07a bg:#1e1e1e"  # Green for high/charged battery

      [time]
      format = "[  $time ]($style)"
      style = "fg:#cdd6f4 bg:#1e1e1e"
      disabled = true

      [localip]
      # See https://starship.rs/config/#localip
      format = " $localipv4 "
      style = "fg:green bold bg:#1e1e1e"
      ssh_only = true
      disabled = false

      [nodejs]
      # See https://starship.rs/config/#nodejs
      symbol = " "
      style = "fg:green bg:#252525"
      format = "[〉$symbol($version )]($style)"
      detect_folders = ["node_modules"]
      detect_files = []
      detect_extensions = []
      disabled = false

      # Docker context
      [docker_context]
      # See https://starship.rs/config/#docker_context
      symbol = " "
      style = "bold fg:blue bg:#252525"
      format = "[〉$symbol$context]($style) "
      disabled = false

      # Terraform
      [terraform]
      # See https://starship.rs/config/#terraform
      symbol = "󱁢 "
      style = "bold fg:purple bg:#252525"
      format = "[〉$symbol$workspace]($style)"
      disabled = false

      # Package version (npm, poetry, etc.)
      [package]
      # See https://starship.rs/config/#package
      symbol = " "
      style = "bold fg:cyan bg:#252525"
      format = "[〉$symbol$version]($style)"
      disabled = false

      # Character
      [character]
      # See https://starship.rs/config/#character
      success_symbol = "[❯](bold green)"
      error_symbol = "[❯](bold red)"
      disabled = false

      # Cloud and containerization indicators
      [aws]
      # See https://starship.rs/config/#aws
      symbol = "󰸏 "
      style = "bold fg:orange bg:#252525"
      format = "on [$symbol($profile )]($style)"
      disabled = false

      # Kubernetes
      [kubernetes]
      # See https://starship.rs/config/#kubernetes
      symbol = "󱃾 "
      style = "bold fg:cyan bg:#252525"
      format = "on [$symbol$context]($style)"
      disabled = false

      # Container
      [container]
      # See https://starship.rs/config/#container
      symbol = " "
      style = "bold fg:red bg:#252525"
      format = '[in $symbol]($style)'
      disabled = false

      # Language-specific indicators
      [rust]
      # See https://starship.rs/config/#rust
      symbol = " "
      style = "bold fg:#ffa500 bg:#252525"
      format = "[〉$symbol($version )]($style)"
      disabled = false

      [golang]
      # See https://starship.rs/config/#golang
      symbol = " "
      style = "bold fg:cyan bg:#252525"
      format = "[〉$symbol($version )]($style)"
      disabled = false

      [java]
      # See https://starship.rs/config/#java
      symbol = " "
      style = "bold fg:red bg:#252525"
      format = "[〉$symbol($version )]($style)"
      disabled = false
    '';
  };
}