# Nimits

A tool for standardizing and linting commits.

Considering creating this for Golang as well, but I believe Nim is more suited to scripting.

This tool is highly inspired by husky and cbeam's [article](https://cbea.ms/git-commit/).

## Features
- Check if your commit messages are too long.
- Add rules to lint your commit message.
- suggest commit messages that better capture what your code does.
- set limits on how large your commits should be
- Integrate Nimit with your favorite code editor or IDE

## Getting started

You will need to install nim. This program allows you to emit
a js version of the code so that you can stick with node as a dependency and not add a new one. However, the preference is that you will use Nim directly and include it in your tool pipeline.

## Installation

### Installation from source 
__(you'll need to do this if you plan to contribute!)__
This requires nim to work.

First, clone the repository. 

```sh
git clone https://github.com/Diogenesoftoronto/nimit
```

Then, change the current working directory to the cloned directory
```sh
cd nimit
```

Compile the program.

```sh
nim c main.nim
```

Run the program, and consider adding it to your $PATH env variable

```sh
./main
```

Nimble is coming with a simpler set of installation instructions.

Currently this is targeted to linux since git only works with unix* machines. 

May work with MACOS, no guarantees at the moment.
