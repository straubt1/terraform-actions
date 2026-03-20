Output assets/04-multiple-actions-02.gif
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

# Navigate, init (hidden)
Hide
Type "cd examples/04-multiple-actions"
Enter
Sleep 1s
Type "terraform init"
Enter
Sleep 5s
Type "clear"
Enter
Sleep 1s
Show

# Invoke individual actions standalone
Type "terraform apply -invoke=action.local_command.backup"
Enter
Sleep 2s
Wait /Enter a value/
Type "yes"
Enter
Sleep 3s

Type "terraform apply -invoke=action.local_command.validate"
Enter
Sleep 2s
Wait /Enter a value/
Type "yes"
Enter
Sleep 3s

Type "terraform apply -invoke=action.local_command.report"
Enter
Sleep 2s
Wait /Enter a value/
Type "yes"
Enter
Sleep 3s

Sleep 3s
