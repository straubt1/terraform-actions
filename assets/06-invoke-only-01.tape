Output assets/06-invoke-only-01.gif
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
Type "cd examples/06-invoke-only"
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

# Normal apply — creates the random_pet resource (no action triggers)
Type "terraform apply"
Enter
Sleep 2s
Wait /Enter a value/
Type "yes"
Enter
Sleep 3s

# Invoke the health check action
Type "terraform apply -invoke=action.local_command.health_check"
Enter
Sleep 2s
Wait /Enter a value/
Type "yes"
Enter
Sleep 3s

# Invoke the cache clear action
Type "terraform apply -invoke=action.local_command.cache_clear"
Enter
Sleep 2s
Wait /Enter a value/
Type "yes"
Enter
Sleep 3s

Sleep 3s
