import { AbstractCommand } from "../abstract/AbstractCommand";
import { sleep } from "../utils";

export class HelloWorldCommand extends AbstractCommand<
  void,
  { message: string }
> {
  async Run(): Promise<{ message: string }> {
    await sleep();
    return {
      message: "Hello world",
    };
  }
}
