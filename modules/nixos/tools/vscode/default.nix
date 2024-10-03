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
let cfg = config.${namespace}.tools.vscode;
in
{
    options.${namespace}.tools.vscode = with types; {
        enable = mkBoolOpt false "Whether or not to install and configure vscode.";
    };

    config = mkIf cfg.enable {
        environment.systemPackages = with pkgs; [
            (vscode-with-extensions.override {
                vscodeExtensions = with vscode-extensions; [
                    bbenoist.nix
                    ms-vscode-remote.remote-containers
                    ms-azuretools.vscode-docker
                ];
            })
        ];
    };
}