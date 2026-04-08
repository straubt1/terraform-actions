Output assets/11-api-03.gif
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
Type "cd examples/11-api"
Enter
Sleep 1s
Type "terraform init"
Enter
Sleep 5s
Type "clear"
Enter
Sleep 1s
Show

# Invoke the API call standalone
Type "terraform apply -invoke=action.local_command.call_api"
Enter
Sleep 2s
Wait /Enter a value/
Type "yes"
Enter
Sleep 5s

# Invoke with an overridden token
Type `terraform apply -invoke=action.local_command.call_api -var api_token="another-token"`
Enter
Sleep 2s
Wait /Enter a value/
Type "yes"
Enter
Sleep 5s

Sleep 3s
