{ config, pkgs, lib, ... }: let 
    inherit (lib) hm mkDefault mkIf mkEnableOption mkOption types; # hasPrefix literalExpression removePrefix;
    inherit (lib) hasPrefix removePrefix literalExpression;

    fileType = opt: basePathDesc: basePath:
    types.attrsOf (types.submodule ({ name, config, ... }: {
      options = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Whether this file should be generated. This option allows specific
            files to be disabled.
          '';
        };

        linkSource = mkOption {
          type = types.str;
          # Check this 
          apply = p:
            let absPath = if hasPrefix "/" p then p else "${basePath}/${p}";
            in removePrefix (homeDirectory + "/") absPath;
          defaultText = literalExpression "name";
          description = ''
            Path to target file relative to ${basePathDesc}.
          '';
        };
      };
    }));
        
    homeDirectory = config.home.homeDirectory;

in {
    # This module removes
    options.workingFiles.file = mkOption {
        description = ''
            workingFiles
        '';
        default = {};
        example = ''
        # neovimConfig = {
        #     enable = true;
        #     linkSource = "${config.home.homeDirectory}/.config/nix/home/nvim";
        # }
        '';
        type = fileType "home.workingFiles" "the home directory" homeDirectory;
    };

    options.workingFiles.enable = mkEnableOption ''
        Enables overriding the home manager symlinks to dotfiles with out of store symlinks to the files in the source directory.
        The symlinks will only be overwritten when 
    '';

    config = let 
        filterEnabled = lib.attrsets.filterAttrs (_: v: v.enable == true) ;

        # Recursively finds all file names in the specified directory and returns a list of them all seperated by a '/' with not prefix
        # relativeNamesRec :: String -> [String]
        relativePathsRec = dir:
            lib.lists.flatten
                (lib.attrsets.mapAttrsToList
                    (name: v:
                        if v == "directory" 
                            then builtins.map (path: "${name}/${path}") (relativePathsRec "${dir}/${name}")
                            else [ name ] )
                    (builtins.readDir dir));
        
        fileList = src: absolutePathToSrc: dst: 
                builtins.map 
                    (path: {source = "${absolutePathToSrc}/${path}"; target = "${dst}/${path}"; } )
                    (relativePathsRec src);

        runNonnull = f: x: if x == null then null else f x;

        intersectionMerge = xattrs: yattrs: 
            lib.attrsets.filterAttrs 
                (_: v: !(builtins.isNull v))
                (lib.attrsets.mapAttrs 
                    (name: ys: runNonnull (xs: xs // ys) (xattrs."${name}" or null))
                    yattrs );

        # trace = x: builtins.trace (builtins.deepSeq x x) x;

        # filesWithoutDisabledNames = builtins.attrNames filesWithoutDisabled;
        vals = 
            builtins.map 
                (lib.attrsets.mapAttrs (_: v: "${homeDirectory}/${v}"))
                (builtins.concatMap 
                    ({linkSource, source, target, recursive, ...}: 
                        if recursive 
                            then fileList source linkSource target 
                            else [{source = linkSource; target = target;}]) 
                    (builtins.attrValues
                        (intersectionMerge 
                            (filterEnabled config.workingFiles.file)
                            (filterEnabled config.home.file))));

    in mkIf config.workingFiles.enable {
        # Need to check if there is a matching entry in `home.files` for each of the entries.
        # It also needs to check if the matching entry uses `text` 
        # assertions = [(
        #   let
        #     dups =
        #       lib.attrNames
        #         (lib.filterAttrs (n: v: v > 1)
        #         (lib.foldAttrs (acc: v: acc + v) 0
        #         (lib.mapAttrsToList (n: v: { ${v.target} = 1; }) cfg)));
        #     dupsStr = lib.concatStringsSep ", " dups;
        #   in {
        #     assertion = dups == [];
        #     message = ''
        #       Conflicting managed target files: ${dupsStr}
        #
        #       This may happen, for example, if you have a configuration similar to
        #
        #           home.file = {
        #             conflict1 = { source = ./foo.nix; target = "baz"; };
        #             conflict2 = { source = ./bar.nix; target = "baz"; };
        #           }'';
        #   })
        # ];

        home.extraActivationPath = with pkgs; [ xorg.lndir ];
        #     # This is VERY much hack
        home.activation.workingDirectoryFiles = hm.dag.entryAfter [ "onFilesChange" ] (''
            # if test -e ''${XDG_STATE_HOME}/nix/profiles/home-manager-''${newGenNum}-profile; then
            #     echo "generation exists"
            # else
            #     echo "This generation does not exist"
            # fi
            # checks if the file 

            symlink() {
              local src="$1"
              local dest="$2"
              if [ -e "$src" ]; then
                ln -sf "$src" "$dest"
                # echo "created symlink"
              # else 
              #   echo "original file didn't exist"
              fi

              # ln -sf "$src" "$dest" && {
              #     echo "updated $dest"
              # } || {
              #     echo "Failed to link file"
              # }
            }
            
            ''  + lib.strings.concatStringsSep "\n" (
                    # builtins.map (v: "run ln -sf ${lib.escapeShellArgs [ v.source v.target ]}") vals
                    builtins.map (v: "symlink ${lib.escapeShellArgs [ v.source v.target ]}") vals
                )
            );
        #     + lib.concatStrings (
        #         # lib.mapAttrsToList (_: v: if v.recursive 
        #         #     then ''run lndir ${
        #         #         lib.escapeShellArgs [
        #         #             "${v.sourceLink}"
        #         #             "${v.target}"
        #         #         ]
        #         #     }
        #         #         # symlink "$homedir/.config/nix/home/nvim" "$homedir/.config/nvim" 
        #         #     ''
        #         #     else ''
        #         #         echo "should symlink";
        #         #     ''
        #         # ) vals
        #         [ '' echo "hi" '']
        #         )
        #     + ''
        #     
        #     echo "-------------------------------------------------------------"
        #     echo "------------ END MANUAL IDEMPOTENT SECTION ----------------"
        #     echo "-------------------------------------------------------------"
        # '';
    };
}
