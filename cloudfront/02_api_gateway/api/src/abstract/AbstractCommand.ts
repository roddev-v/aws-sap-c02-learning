export abstract class AbstractCommand<Input, Output>
  implements Types.Abstract.Command<Input, Output>
{
  abstract Run(input?: Input): Output | Promise<Output>;
}
