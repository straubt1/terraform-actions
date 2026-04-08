Output assets/10b-foreach-action-02.gif
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
Type "cd examples/10b-foreach-action"
Enter
Sleep 1s
Type "terraform init"
Enter
Sleep 5s
Type "clear"
Enter
Sleep 1s
Show

# Re-trigger one resource and its matching action
Type `terraform apply -replace='random_pet.this["bravo"]'`
Enter
Sleep 2s
Wait /Enter a value/
Type "yes"
Enter
Sleep 3s

Sleep 3s
