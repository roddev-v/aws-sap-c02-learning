import { CachedHandler } from "../abstract/CachedHandler";
import { CommandBWithTTL } from "../commands/CommandBWithTTL";

export const handler = new CachedHandler(new CommandBWithTTL()).handler;
