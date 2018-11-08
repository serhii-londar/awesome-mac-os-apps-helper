# awesome-mac-os-apps-helper

## Description

Small utility to help add repositories to [open-source-mac-os-apps](https://github.com/serhii-londar/open-source-mac-os-apps) list.

This command line utility will help you to generate a markdown description with app screenshots for your repository: Example:

- [DBeaver](https://github.com/dbeaver/dbeaver) - Universal database tool and SQL client. ![java_icon] <details> <summary> Screenshots </summary> <p float="left">  <bt><img src='https://dbeaver.io/product/dbeaver-ss-mock.png' width="400"/>  <bt><img src='https://dbeaver.io/product/dbeaver-ss-mock.png' width="400"/>  <bt><img src='https://dbeaver.io/product/dbeaver-ss-erd.png' width="400"/>  <bt><img src='https://dbeaver.io/product/dbeaver-ss-erd.png' width="400"/>  <bt><img src='https://dbeaver.io/product/dbeaver-ss-classic.png' width="400"/>  <bt><img src='https://dbeaver.io/product/dbeaver-ss-classic.png' width="400"/>  <bt><img src='https://dbeaver.io/product/dbeaver-ss-dark.png' width="400"/>  <bt><img src='https://dbeaver.io/product/dbeaver-ss-dark.png' width="400"/>  </p></details> 

## Usage

### Generate repository description

Having checked out the repo, build it through Xcode or by running
```
swift build
``` 
in your terminal. This will create an executable (when run in command line, it will be in the default Swift build directory, typically `.build/<architecture>/debug`), and can be run as:

```
./awesome-mac-os-apps-helper --repoUrl 'https://github.com/dbeaver/dbeaver' --description 'Universal database tool and SQL client.' --language 'Java'
```

This command will generate dbeaver.md file with a complete repository description. After that you can create a [Pull Request](https://github.com/serhii-londar/open-source-mac-os-apps/compare) to [open-source-mac-os-apps](https://github.com/serhii-londar/open-source-mac-os-apps).

### Supported languages

There is also a command to show all programming languages supported in the repository:

```
$ ./awesome-mac-os-apps-helper --languages
c
cpp
c_sharp
clojure
coffee_script
css
elm
haskell
java
javascript
lua
objective_c
python
ruby
rust
swift
type_script
```

### Help

You can see available option by using the command
```
$ ./awesome-mac-os-apps-helper --help
--repoUrl - repository url
--description - repository description
--language - repository language
--languages - view all avalaible languages
```

[java_icon]: ./icons/java-16.png 'Java language.'
