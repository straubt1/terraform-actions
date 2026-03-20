Output assets/02-old-way-vs-new-way-04.gif
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

# Navigate to new-way, init, apply to create state (hidden)
Hide
Type "cd examples/02-old-way-vs-new-way/new-way"
Enter
Sleep 1s
Type "terraform init"
Enter
Sleep 5s
Type "terraform destroy -auto-approve"
Enter
Sleep 5s
Type "terraform apply -auto-approve"
Enter
Sleep 8s
Type "clear"
Enter
Sleep 1s
Show

# New way: invoke action standalone
Type "terraform apply -invoke=action.local_command.notify"
Enter
Sleep 2s
Wait /Enter a value/
Type "yes"
Enter
Sleep 3s

Sleep 3s
