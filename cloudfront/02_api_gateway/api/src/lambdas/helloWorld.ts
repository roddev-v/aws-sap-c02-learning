import { Handler } from "../abstract/Handler";
import { HelloWorldCommand } from "../commands/HelloWorldCommand";

const lambda = new Handler(new HelloWorldCommand());

export const handle = lambda.handler;
