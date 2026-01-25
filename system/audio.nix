{ lib, pkgs, config, options, ... }: {
  # ----- Bluetooth -----
    hardware.bluetooth = {
        enable = true;
        powerOnBoot = true; # powers up the default Bluetooth controller on boot
        settings = {
            General = {
                Enable = "Source,Sink,Media,Socket";
                Experimental = true;
                MultiProfile = "multiple";
                Disable = "Headset";
            };
        };
    };

    services.blueman.enable = true;
    services.pulseaudio.enable = false;
    services.pipewire  = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
        # If you want to use JACK applications, uncomment this
        #jack.enable = true;
        # wireplumber.extraConfig.bluetoothEnhancements = {
        #
        #     "monitor.bluez.properties" = {
        #         "bluez5.enable-sbc-xq" = true;
        #         "bluez5.enable-msbc" = true;
        #         "bluez5.enable-hw-volume" = true;
        #         "bluez5.roles" = [ "a2dp_sink" "a2dp_source" /*"bap_sink" "bap_source"*/ "hsp_hs" /* "hsp_ag" */ "hfp_hf" /* "hfp_ag" */  ];
        #         "bluez5.codecs" = [ "sbc" "sbc_xq" "aac" "ldac" "aptx" "aptx_hd" "aptx_ll" "aptx_ll_duplex" "faststream" "faststream_duplex" "lc3plus_h3" "opus_05" /*"opus_05_51" "opus_05_71"*/ "lc3" ];
        #
        #         /*opus_05_duplex, opus_05_pro,*/ 
        #     };
        # };
    };
    security.rtkit.enable = true;

    environment.systemPackages = with pkgs; [
        pulseaudioFull
        # Console mixer
        pulsemixer
        # Equalizer on sterids
        easyeffects
        # bluetooth control
        overskride
    ];
}
