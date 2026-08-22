submodules:
    git submodule update --init --recursive

hm_swich:
    home-manager switch

nixos_rebuild_switch:
    sudo nixos_rebuild switch


combine_sinks:
    pactl load-module module-combine-sink sink_name=combined slaves=Arctis_Media,alsa_output.usb-SteelSeries_Arctis_Nova_3X_Wireless-00.analog-stereo

delete_combined:
    pactl unload-module combined


