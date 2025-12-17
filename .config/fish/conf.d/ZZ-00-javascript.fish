set -gx DENO_INSTALL ~/.deno
set -gx NPM_CONFIG_PREFIX $HOME/.local/
set -x NODE_ENV
set -x NODE_OPTIONS --max_old_space_size=4096
# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

if status is-interactive
  function nvm_use_on_dir --on-variable PWD
    if test -e ./.nvmrc
      nvm -s use
    else if type -q node
      nvm -s use system
    end
  end

  nvm_use_on_dir
end
