import { AbstractCommand } from "./AbstractCommand";

export abstract class CachedCommand<
    Input,
    Output extends { cacheControl: string, data: unknown }
  >
  extends AbstractCommand<Input, Output>
  implements Types.Abstract.Command<Input, Output>
{
  abstract Run(input?: Input): Output | Promise<Output>;
}
