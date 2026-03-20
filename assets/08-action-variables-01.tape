Output assets/08-action-variables-01.gif
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
Type "cd examples/08-action-variables"
Enter
Sleep 1s
Type "terraform init"
Enter
Sleep 5s
Type "clear"
Enter
Sleep 1s
Show

# Invoke with default variable values
Type "terraform apply -invoke=action.local_command.greet"
Enter
Sleep 2s
Wait /Enter a value/
Type "yes"
Enter
Sleep 3s

# Override message variable from CLI
Type "terraform apply -invoke=action.local_command.greet -var 'message=hello from CLI'"
Enter
Sleep 2s
Wait /Enter a value/
Type "yes"
Enter
Sleep 3s

# Override both message and log_level
Type "terraform apply -invoke=action.local_command.greet -var 'message=custom message' -var 'log_level=debug'"
Enter
Sleep 2s
Wait /Enter a value/
Type "yes"
Enter
Sleep 3s

# Invoke the inline info action
Type "terraform apply -invoke=action.local_command.info"
Enter
Sleep 2s
Wait /Enter a value/
Type "yes"
Enter
Sleep 3s

# Invoke info with overridden variables
Type "terraform apply -invoke=action.local_command.info -var 'message=overridden' -var 'log_level=warn'"
Enter
Sleep 2s
Wait /Enter a value/
Type "yes"
Enter
Sleep 3s

Sleep 3s
