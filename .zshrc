# -----------------------------------
# Set up prompt environment variable
# -----------------------------------
RPROMPT=' %DT%D{%H:%M:%S}'
function promptcmd {
    PROMPT="%F{cyan}%~%f$(build_git_prompt) %% "
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

       # Build the result string
       result=

       # Add the modified file count to the result string
       if [ "${mod_count}" != "0" ]; then
           result=" %F{cyan}*${mod_count}%f"
       fi

       # Add the added file count to the result string
       if [ "${added_count}" != "0" ]; then
           result="${result} %F{green}+${added_count}%f"
       fi

       # Add the deleted file count to the result string
       if [ "${deleted_count}" != "0" ]; then
           result="${result} %F{red}-${deleted_count}%f"
       fi

       # Add the untracked file count to the result string
       if [ "${untracked_count}" != 0 ]; then
           result="${result} %F{yellow}~${untracked_count}%f"
       fi

       echo -e " (%F{magenta}${branch_name}%f${result})";
   fi
}