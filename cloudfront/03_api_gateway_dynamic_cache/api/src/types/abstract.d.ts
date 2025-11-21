export namespace Abstract {
  interface SimpleCommand<Output> {
    Run(): Output | Promise<Output>;
  }

  interface Command<Input, Output> {
    Run(input: Input | undefined): Output | Promise<Output>;
  }
}
