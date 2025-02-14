# Features and bug fixes 


### arrow key navigationz | DONE
In vim, `split` and `vsplit` are very useful, but taversing between splits can 
be tedious. The arrow keys are not needed to edit text, so but they are present 
on almost all modern keyboards, so they are repurposed in normal mode and
terminal mode to navigate between windows instead. 
#### Additional features
There are addional features that further enhance this mod:
- when no window exists in the direction the user attempts to travel with the
  arrow keys, a new window is create.  | DONE
- when new windows are created like this, they split in the direction the user
  was trying to travel. | DONE
- new splits created in this fashon start in explore mode from the starting
  buffer's parent directry. | DONE
- When leaving a window with the arrow keys, if it is empty and unnamed, or if
  it is a netrw listing of cwd, the window is considered unused and is closed
  automattically | DONE

### dynamic link following | PENDING
<c-]> jumps to a tagged reference under <cword>. If <cword> is not a tagged
object but a file path, that file should be opened instead. If it is a relitive,
path, `expand('%:d')` (folder containing %) should be used as the root, if that
file doesn't exist, try from cwd. If it is a web link, open it in the default
web browser. As with <c-]>'s current functinoallity, if the % has unsaved
changes, a split is made before opening the new file. 

### Advanced AIChat features | PENDING
- when a build fails using :make or :Cargo or whatever else I start using, the
  compiler output is piped directly to a new AIChat buffer prefixed with a
  prompt for finding a solution
- Allow for multiple instances of AIChat simaltaniously. chatgpt's oem client
  does this, so it should be no problem.
- Dispatch it async so I can edit text files while it is loading. Make it look
  look `:Cargo` looks.
- allow for changing API settings via vimrc settings.
- make responses fit in window frame? might not be a good idea, but an optional
  feature where the window size of the chat buffer is checked (row and column
  count), and some prefix is added to the ai prompt saying: "response must not
  exceed x chars wide and y chars tall" This won't always work, but will make
  most resonses fit, and even the ones that don't won't be larger than they have
  to be i think. we'll see...
