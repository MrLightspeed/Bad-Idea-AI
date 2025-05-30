# Contributing to Bad Idea AI

Thank you for considering contributing to this project! Follow the steps below to get started.

## Fork and Clone

1. Fork the repository on GitHub.
2. Clone your fork and create a new branch:
   ```sh
   git clone https://github.com/<your-username>/Bad-Idea-AI.git
   cd Bad-Idea-AI
   git checkout -b my-feature
   yarn install
   ```

## Testing

Run the formatter before committing:

```sh
yarn format
```

The Husky pre-commit hook will verify formatting with `yarn prettier --check .`.

## Commit Message Style

Use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) when writing commit messages. Example:

```
feat: add awesome feature
```

## Opening a Pull Request

1. Push your branch to your fork.
2. Open a pull request against the `main` branch of this repository.
3. Fill out the PR template and reference any related issues.
