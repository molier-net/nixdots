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
let cfg = config.${namespace}.user;
in
{
    options.${namespace}.user = with types; {
        name = mkOpt str "remko" "The name to use for the user account.";
        fullName = mkOpt str "Remko Molier" "The full name of the user.";
        email = mkOpt str "remko.molier@googlemail.com" "The email of the user.";
        initialPassword = mkOpt str "password" "The initial password to use when the user is first created.";
        extraGroups = mkOpt (listOf str) [ ] "Groups for the user to be assigned.";
        extraOptions = mkOpt attrs { } (mdDoc "Extra options passed to `users.users.<name>`.");
    };

    config = {
        
        nixdots.home = {
            file = {
                "Desktop/.keep".text = "";
                "Documents/.keep".text = "";
                "Downloads/.keep".text = "";
                "Music/.keep".text = "";
                "Pictures/.keep".text = "";
                "Videos/.keep".text = "";
            };
        };

        # Define a user account. Don't forget to set a password with ‘passwd’.
        users.users.${cfg.name} = {
            isNormalUser = true;

            inherit (cfg) name initialPassword;

            group = "users";

            description = cfg.fullName;
            extraGroups = cfg.extraGroups;
            
        } // cfg.extraOptions;
    };
}