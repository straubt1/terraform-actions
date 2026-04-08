Output assets/09-environment-variables-02.gif
Require terraform

Set Shell bash
Set Theme "Catppuccin Mocha"
Set FontSize 16
Set FontFamily "RobotoMono Nerd Font"
Set Width 1200
Set Height 800
Set Padding 20
Set Framerate 30
Set PlaybackSpeed 0.75
Set TypingSpeed 75ms
Set WaitTimeout 30s

# Navigate, init (hidden)
Hide
Type "cd examples/09-environment-variables"
Enter
Sleep 1s
Type "terraform init"
Enter
Sleep 5s
Type "clear"
Enter
Sleep 1s
Show

# Override `environment` via -var, and set LOG_LEVEL in the parent shell
Type `LOG_LEVEL=debug terraform apply -replace=random_pet.this -var environment="production"`
Enter
Sleep 2s
Wait /Enter a value/
Type "yes"
Enter
Sleep 3s

Sleep 3s
