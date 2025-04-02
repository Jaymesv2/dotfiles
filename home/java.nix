{ pkgs, ... }: {
    home.file = { 
        "java/java8" = {
            source = pkgs.jdk8;
            target = ".local/java/java8";
        };
        "java/java17" = {
            source = pkgs.jdk17; 
            target = ".local/java/java17";
        };
        
        "java/java23" = { 
            source = pkgs.jdk23; 
            target = ".local/java/java23";
        };
        "java/graalvm" = { 
            source = pkgs.graalvm-ce; 
            target = ".local/java/graalvm";
        };
        # "default/useradd".text = "GROUP=100 ...";
    };
}
