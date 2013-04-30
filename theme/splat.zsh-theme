

is_virtual_machine() {
    if [ -f /etc/.qemu_device ]; then
        return 0;
    fi 

    return 1;
}

is_ssh_shell() {
    if [ -n "$SSH_CLIENT" -o -n "$SSH_CONNECTION" -o -n "$SSH_TTY" ];then
        return 0;
    fi

    return 1;
}         


typeset -Ag T R S

case "$TERM" in
    xterm-256color | fbterm)
        T=( BINDER %F{033} USER %F{081} HOST %F{166} PATH %F{147} )
        R=( DEV %F{082} STAGE %F{226} PROD %F{196} )
        S=( LCL %f SSH %F{081} VRT %F{201} ) 
      ;;
    *)
        T=( BINDER %B%F{004} USER %B%F{006} HOST %F{005} PATH %F{002} )
        R=( DEV %F{002} STAGE %B%F{003} PROD %B%F{001} )
        S=( LCL %f SSH %F{006} VRT %F{005} ) 
      ;;
esac


PROMPT='$T[BINDER]('

case "$BOX_RISK_LEVEL" in
    2)
        PROMPT="$PROMPT$R[DEV]"
        ;;
    1)
        PROMPT="$PROMPT$R[STAGE]"
        ;;
    0)
        PROMPT="$PROMPT$R[PROD]"
        ;;
    *)
        PROMPT="$PROMPT%f"
        ;;
esac
PROMPT="$PROMPT●"


if is_virtual_machine; then
    PROMPT="$PROMPT$S[VRT]"
elif is_ssh_shell; then
    PROMPT="$PROMPT$S[SSH]"
else
    PROMPT="$PROMPT$S[LCL]"
fi
PROMPT="$PROMPT●"


PROMPT="$PROMPT$T[BINDER]) $T[USER]%n$T[BINDER]@$T[HOST]%m$T[BINDER]:$T[PATH]%~ $T[BINDER]%#%f%b "
export PROMPT

return 0
