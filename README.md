# Nimit

A tool for standardizing and linting commits.

<!-- TABLE OF CONTENTS -->
## Table of Contents

- [Nimit](#nimit)
  - [Table of Contents](#table-of-contents)
  - [Motivation](#motivation)
  - [Features](#features)
  - [Getting started](#getting-started)
  - [Installation](#installation)
    - [Dependencies](#dependencies)
    - [Installation from source](#installation-from-source)

## Motivation

The reason behind this tool emerged after constantly getting my pull requests rejected because of something minor like incorrect spelling or because it was over 50 characters. Something I believe could be easily checked by a computer. I also wanted to make sure my commits in my other open source projects could be easily checked so that other developers would not have to read over a commit to make sure it was good. I wanted to build a tool that would solve this problem and that would integrate well with ci and my editor. The vision for that tool realised (hopefully) is Nimit. Nimit is designed to be a no nonsense performant linter of commits you can plug straight into CI with very little dependencies.

This tool is highly inspired by husky and cbeam's [article](https://cbea.ms/git-commit/).

## Features

- Check if your commit messages are too long.
- Add rules to lint your commit message.
- Suggest commit messages that better capture what your code does.
- Set limits on how large your commits should be.
- Integrate Nimit with your favorite code editor or IDE.

## Getting started

You will need to install nim. This program allows you to emit
a js version of the code so that you can stick with node as a dependency and not add a new one. However, the preference is that you will use Nim directly and include it in your tool pipeline.

## Installation

### Dependencies

- [Nim](https://nim-lang.org/install.html)
- [Git](https://git-scm.com/downloads)
- [Vale](https://vale.sh/docs/vale-cli/installation/)

NOTE: I plan on removing the vale dependency in the future.

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
