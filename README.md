# awesome-mac-os-apps-helper

## Description

Small utility to help add repositoriest to [open-source-mac-os-apps](https://github.com/serhii-londar/open-source-mac-os-apps) list.

This command line utility will help you to generate all markdown description for your repository with app screenshots: Example:

- [DBeaver](https://github.com/dbeaver/dbeaver) - Universal database tool and SQL client. ![java_icon] <details> <summary> Screenshots </summary> <p float="left">  <bt><img src='https://dbeaver.io/product/dbeaver-ss-mock.png' width="400"/>  <bt><img src='https://dbeaver.io/product/dbeaver-ss-mock.png' width="400"/>  <bt><img src='https://dbeaver.io/product/dbeaver-ss-erd.png' width="400"/>  <bt><img src='https://dbeaver.io/product/dbeaver-ss-erd.png' width="400"/>  <bt><img src='https://dbeaver.io/product/dbeaver-ss-classic.png' width="400"/>  <bt><img src='https://dbeaver.io/product/dbeaver-ss-classic.png' width="400"/>  <bt><img src='https://dbeaver.io/product/dbeaver-ss-dark.png' width="400"/>  <bt><img src='https://dbeaver.io/product/dbeaver-ss-dark.png' width="400"/>  </p></details> 

## Ussage

### Generate repository description

You can build it by checkouting this repo. After you biuld it open folder with executable and run:

```
./awesome-mac-os-apps-helper --repoUrl 'https://github.com/dbeaver/dbeaver' --description 'Universal database tool and SQL client.' --language 'Java'
```

This command will generate dbeaver.md file with compleated repository description. After that you can create [Pull Request](https://github.com/serhii-londar/open-source-mac-os-apps/compare) to [open-source-mac-os-apps](https://github.com/serhii-londar/open-source-mac-os-apps).

### Supported languages

Also there is command with awailable languages:

```
./awesome-mac-os-apps-helper --languages
```

Output:

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

You can get help by entering following command:

```
./awesome-mac-os-apps-helper --help
```

Output:

```
$ ./awesome-mac-os-apps-helper --help
--repoUrl - repository url
--description - repository description
--language - repository language
--languages - view all avalaible languages
```

[java_icon]: ./icons/java-16.png 'Java language.'