{
    # Snowfall Lib provides a customized `lib` instance with access to your flake's library
    # as well as the libraries available from your flake's inputs.
    lib,
    # An instance of `pkgs` with your overlays and packages applied is also available.
    pkgs,
    # You also have access to your flake's inputs.
    inputs,

    # Additional metadata is provided by Snowfall Lib.
    namespace, # The namespace used for your flake, defaulting to "internal" if not set.
    system, # The system architecture for this host (eg. `x86_64-linux`).
    target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
    format, # A normalized name for the system target (eg. `iso`).
    virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
    systems, # An attribute map of your defined hosts.

    # All other arguments come from the module system.
    config,
    ...
}:
with lib;
with lib.${namespace};
let cfg = config.${namespace}.tools.git;
    gpg = config.${namespace}.security.gpg;
    user = config.${namespace}.user;
in
{
    options.${namespace}.tools.git = with types; {
        enable = mkBoolOpt false "Whether or not to install and configure git.";
        userName = mkOpt types.str user.fullName "The name to configure git with.";
        userEmail = mkOpt types.str user.email "The email to configure git with.";
        signingKey = mkOpt types.str "9762169A1B35EA68" "The key ID to sign commits with.";
    };

    config = mkIf cfg.enable {
        
        environment.systemPackages = with pkgs; [
            git
            git-crypt
        ];

        nixdots.home.extraOptions = {
            programs.git = {
                enable = true;
                inherit (cfg) userName userEmail;
                lfs = enabled;
                signing = {
                    key = cfg.signingKey;
                    signByDefault = mkIf gpg.enable true;
                };
                extraConfig = {
                    init = {
                        defaultBranch = "main";
                    };
                    pull = {
                        rebase = true;
                    };
                    push = {
                        autoSetupRemote = true;
                    };
                };
            };
        };
    };
}