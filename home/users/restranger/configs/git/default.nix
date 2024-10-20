{
  programs.git = {
    enable = true;
    userName  = "ReStranger";
    userEmail = "strengerplayr@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      http = {
        postBuffer = 524288000;
        lowSpeedLimit = 0;
        lowSpeedTime = 999999;
      };
    };
  };
}
