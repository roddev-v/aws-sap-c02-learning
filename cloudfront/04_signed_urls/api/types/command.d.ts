export namespace Commands {
  interface Command<Input, Output> {
    Run(
      input: Input | undefined
    ): Output | undefined | Promise<Output | undefined>;
  }
}
