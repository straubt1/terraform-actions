Output assets/07-inline-script-01.gif
Require terraform

Set Shell bash
Set Theme "Catppuccin Mocha"
Set FontSize 16
Set FontFamily "Roboto Mono"
Set Width 1200
Set Height 800
Set Padding 20
Set Framerate 30
Set PlaybackSpeed 0.75
Set TypingSpeed 75ms
Set WaitTimeout 30s

# Navigate, init, clean state (hidden)
Hide
Type "cd examples/07-inline-script"
Enter
Sleep 1s
Type "terraform init"
Enter
Sleep 5s
Type "terraform destroy -auto-approve"
Enter
Sleep 5s
Type "clear"
Enter
Sleep 1s
Show

# Create — runs the inline script after the resource is created
Type "terraform apply"
Enter
Sleep 2s
Wait /Enter a value/
Type "yes"
Enter
Sleep 3s

# Force recreate — runs the inline script again
Type "terraform apply -replace=random_pet.this"
Enter
Sleep 2s
Wait /Enter a value/
Type "yes"
Enter
Sleep 3s

Sleep 3s
