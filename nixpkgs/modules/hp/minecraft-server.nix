# This module is responsible for minecraft server
{ config, pkgs, inputs, system, ... }:

{
  services.minecraft-server = {
    enable = true;
    eula = false;
    declarative = true;
    serverProperties = {
      server-port = 25565;
      gamemode = "survival";
      motd = "Testing...";
      max-players = 10;
    };
  };
}
