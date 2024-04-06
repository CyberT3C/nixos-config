{

RC = ''
  # try different remapping of <leader> key
  # I am not sure what like the most 
  # looks like most ppl use ctrl and space or ctrl and a
  unbind C-b
  set -g prefix C-Space
  bind C-Space send-prefix

  # window navigation
  |<shift>a| -> next window
  |<shift>q| -> prev window
  bind -n S-a  previous-window
  bind -n S-q next-window

  # pane navigation
  # |<alt>[h,j,k,l]|
  bind -n M-h select-pane -L
  bind -n M-l select-pane -R
  bind -n M-k select-pane -U
  bind -n M-j select-pane -D

  # toogle pane fullscreen and back
  bind Space resize-pane -Z


  # split panes  
  # -f -bf -fh -bfh == bottom top right left    -h -v == horizontal vertical
  
  # vim style
  # |<leader>hjkl| -> normal split, 
  # |<leader>nm,.| -> small splits    (% for widescreen)
  
  bind h split-window -bfh -c "#{pane_current_path}"
  bind j split-window -f -c "#{pane_current_path}"
  bind k split-window -bf -c "#{pane_current_path}"
  bind l split-window -fh -c "#{pane_current_path}"

  # split by percentag is -p and -l by lines
  # i think i want commands for a small split
  bind n split-window -p 30 -bfh -c "#{pane_current_path}"
  bind m split-window -p 24 -f -c "#{pane_current_path}"
  bind , split-window -p 24 -bf -c "#{pane_current_path}"
  bind . split-window -p 30 -fh -c "#{pane_current_path}"

  # intuitve switching [1..n]
  set -g base-index 1
  set -g pane-base-index 1    

'';
    
}
