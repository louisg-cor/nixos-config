{ config, ... }:
{
  services.syncthing =
  {
    enable = true;
  };

  services.syncthing.settings =
  {
    devices =
    {
      "myPhone" =
      {
        id = "W3XMLW3-Y3G3S54-GC2FNGU-VDL6U64-UTWOKFH-HMQZVPK-PFKE5TD-UJXPVAT";
        autoAcceptFolders = true;
      };
    };
    folders =
    {
      "music-id" =
      {
        path = "${config.home.homeDirectory}/Music";
        label = "Music";
        type = "sendreceive";
        versioning =
        {
          type = "staggered";
          params =
          {
            cleanInterval = "3600";
            maxAge = "15552000";
          };
        };
      };
      "notes-id" =
      {
        path = "${config.home.homeDirectory}/2nd_Brain";
        label = "Notes";
        type = "sendreceive";
        versioning =
        {
          type = "staggered";
          params =
          {
            cleanInterval = "3600";
            maxAge = "15552000";
          };
        };
      };
    };
  }; 
}
