import * as AppServices from './services';
import * as AppCommands from './command';

declare global {
  namespace AppTypes {
    export import Services = AppServices.Services;
    export import Commands = AppCommands.Commands;
  }
}

export {};