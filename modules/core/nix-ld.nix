{ pkgs, ... }:
{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
            zlib                                                                                                                                                                      
zstd                                                                                                                                                                      
stdenv.cc.cc                                                                                                                                                              
stdenv.cc.cc.lib                                                                                                                                                          
udev                                                                                                                                                                      
dbus                                                                                                                                                                      
mesa                                                                                                                                                                      
libglvnd                                                                                                                                                                  
curl                                                                                                                                                                      
openssl                                                                                                                                                                   
];
  };
}
