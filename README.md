# UserDefaultsItem

### Usage example

```
struct UserSettings {
  @UserDefaultsItem(key: "username", defaultValue: "a default value returned if no persisted value for key 'username' is found")
  var username: String
}

func persistUsername() {
  var settings = UserSettings()
  settings.username = "John Appleseed"
}

func retrieveUsername() -> String {
  let settings = UserSettings()
  return settings.username
}
```
