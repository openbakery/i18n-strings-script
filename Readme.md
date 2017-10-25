# i18n Scripts

This scripts helps to manipulate the Localizable.strings file in iOS, macOS, tvOS or watchOS projects.

* `set-value.rb` - Overrides or adds a new value to all strings file
* `import.rb` - Import all values from a given strings file to another. Only existing values are imported. Also the comments are honored
* `delta.rb` - Creates a delta of the missing translations and stores it in txt files
* `sort.rb` - Sorts the strings file. Comments are also honored.
