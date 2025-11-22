import { CachedHandler } from "../abstract/CachedHandler";
import { CommandAWithTTL } from "../commands/CommandAWithTTL";

export const handle = new CachedHandler(new CommandAWithTTL()).handler;
