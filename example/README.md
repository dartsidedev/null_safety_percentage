This is an example project to test the `null_safety_percentage` command-line tool.

```
$ dart run null_safety_percentage --help
$ dart run null_safety_percentage lib test
$ dart run null_safety_percentage lib test --output-format json
$ dart run null_safety_percentage lib --verbose
```

If the `null_safety_percentage` tool globally installed, you can shorten the commands above like this:

```
$ null_safety_percentage lib test --output-format json
```