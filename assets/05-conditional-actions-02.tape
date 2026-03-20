Output assets/05-conditional-actions-02.gif
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
Set WaitTimeout 60s

# Navigate, init, apply to create state (hidden)
Hide
Type "cd examples/05-conditional-actions"
Enter
Sleep 2s
Type "terraform init"
Enter
Sleep 10s
Type "terraform destroy -auto-approve"
Enter
Sleep 10s
Type "terraform apply -auto-approve"
Enter
Sleep 15s
Type "clear"
Enter
Sleep 2s
Show

# Invoke check_env (dev — default)
Type "terraform apply -invoke=action.local_command.check_env"
Enter
Sleep 2s
Wait /Enter a value/
Type "yes"
Enter
Sleep 5s

# Invoke check_env (prod — triggers warning)
Type "terraform apply -invoke=action.local_command.check_env -var environment=prod"
Enter
Sleep 2s
Wait /Enter a value/
Type "yes"
Enter
Sleep 5s

# Invoke log_change standalone
Type "terraform apply -invoke=action.local_command.log_change"
Enter
Sleep 2s
Wait /Enter a value/
Type "yes"
Enter
Sleep 5s

Sleep 3s
