return {
  'goerz/jupytext.nvim',
  version = '0.2.0',
  lazy = false,
  opts = {
    jupytext = '/opt/homebrew/Caskroom/mambaforge/base/envs/idp_env/bin/jupytext',
    format = 'py:percent', -- Python with # %% cell markers
    update = true, -- preserve existing cell outputs in .ipynb on save
  },
}
