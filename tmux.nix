{

RC = ''
  # try different remapping of <leader> key
  # I am not sure what like the most 
  # looks like most ppl use ctrl and space or ctrl and a
  unbind C-b
  set -g prefix C-Space
  bind C-Space send-prefix

  # alt + arrows is what alot of ppl use or <leader> with hjkl
  # that is not fitting for me
  # |<alt>[h,j,k,l]|
  bind -n M-h select-pane -L
  bind -n M-l select-pane -R
  bind -n M-k select-pane -U
  bind -n M-j select-pane -D

  # split panes  
  # -f -bf -fh -bfh == bottom top right left    -h -v == horizontal vertical
  
  # vim style
  # |<leader>h,j,k,l| -> normal split, 
  # ||<leader>MISSING| -> small splits      (30%)
  
  bind h split-window -bfh -c "#{pane_current_path}"
  bind j split-window -f -c "#{pane_current_path}"
  bind k split-window -bf -c "#{pane_current_path}"
  bind l split-window -fh -c "#{pane_current_path}"

  # split by percentag is -p and -l by lines
  # i think i want commands for a small split
  bind n split-window -p 30 -bfh -c "#{pane_current_path}"
  bind m split-window -p 30 -f -c "#{pane_current_path}"
  bind , split-window -p 30 -bf -c "#{pane_current_path}"
  bind . split-window -p 30 -fh -c "#{pane_current_path}"

  # intuitve switching [1..n]
  set -g base-index 1
  set -g pane-base-index 1    

'';
    
}
