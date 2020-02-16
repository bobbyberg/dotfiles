# -----------------------------------
# Set up prompt environment variable
# -----------------------------------
function promptcmd {
    PROMPT="%F{cyan}%~%f$(build_git_prompt) %% "
    RPROMPT=' %DT%D{%H:%M:%S}'
}
precmd_functions=(promptcmd)

# -----------------------------------
# FUNCTIONS
# -----------------------------------
function git_branch {
   branch_name=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/');
   echo "${branch_name}";
}

function git_modification_count {
   echo $(git status --porcelain | grep -E '^( M|M |AM) ' 2>/dev/null | wc -l)
}

function git_untracked_count {
   echo $(git status --porcelain | grep -E '^\?\? ' 2>/dev/null | wc -l)
}

function git_added_count {
   echo $(git status --porcelain | grep -E '^A' 2>/dev/null | wc -l)
}

function git_deleted_count {
   echo $(git status --porcelain | grep -E '^D ' 2>/dev/null | wc -l)
}

function build_git_prompt {
   branch_name=$(git_branch);
   if [ -z "${branch_name}" ]; then
       echo "";
   else
       # Get counts of changes to the repo
       mod_count=$(git_modification_count);
       added_count=$(git_added_count);
       deleted_count=$(git_deleted_count);
       untracked_count=$(git_untracked_count);

       # Set up colors
       # See http://tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
       color_main="\e[1;35m";
       color_mod="\e[1;36m";
       color_added="\e[1;32m";
       color_deleted="\e[1;31m";
       color_untracked="\e[1;33m";
       color_reset="\e[0m";

       # Build the result string
       result=

       # Add the modified file count to the result string
       if [ "${mod_count}" != "0" ]; then
           result=" ${color_mod}*${mod_count}"
       fi

       # Add the added file count to the result string
       if [ "${added_count}" != "0" ]; then
           result="${result} ${color_added}+${added_count}"
       fi

       # Add the deleted file count to the result string
       if [ "${deleted_count}" != "0" ]; then
           result="${result} ${color_deleted}-${deleted_count}"
       fi

       # Add the untracked file count to the result string
       if [ "${untracked_count}" != 0 ]; then
           result="${result} ${color_untracked}~${untracked_count}"
       fi

       echo -e " (${color_main}${branch_name}${result}${color_reset})";
   fi
}