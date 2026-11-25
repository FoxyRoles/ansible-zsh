if [[ -o interactive ]]; then
    # Zinit initializes completion after the plugins have loaded.
    skip_global_compinit=1
fi
