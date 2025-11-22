import { CachedHandler } from "../abstract/CachedHandler";
import { CommandBWithTTL } from "../commands/CommandBWithTTL";

export const handle = new CachedHandler(new CommandBWithTTL()).handler;
